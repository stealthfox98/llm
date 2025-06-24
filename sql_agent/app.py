from dotenv import load_dotenv
from langchain_google_genai import ChatGoogleGenerativeAI
from langchain_community.agent_toolkits import SQLDatabaseToolkit
from langchain_community.utilities import SQLDatabase
from langchain_community.tools.sql_database.tool import QuerySQLDatabaseTool

from langchain_core.messages import AIMessage, HumanMessage
from langchain_core.prompts import ChatPromptTemplate
from langchain_core.runnables import RunnablePassthrough
from langchain_core.output_parsers import StrOutputParser

import streamlit as st

def init_database(db_user: str, db_password: str, db_host: str, db_name: str) -> SQLDatabase:
    db_uri = f"mysql+pymysql://{db_user}:{db_password}@{db_host}/{db_name}"
    return SQLDatabase.from_uri(db_uri)

EXPORT CORE FUNCTIONALITIES FROM NOTEBOOK AND ADAPT IT TO MAIN.PY

def get_sql_chain(db):
    template = """
    You are a SQL expert with a strong attention to detail.
    Double check the {dialect} query for common mistakes, including:
    - Using NOT IN with NULL values
    - Using UNION when UNION ALL should have been used
    - Using BETWEEN for exclusive ranges
    - Data type mismatch in predicates
    - Properly quoting identifiers
    - Using the correct number of arguments for functions
    - Casting to the correct data type
    - Using the proper columns for joins

    If there are any of the above mistakes, rewrite the query. If there are no mistakes,
    just reproduce the original query.

    Don't limit the query output.

    You will call the appropriate tool to execute the query after running this check.
    """.format(dialect=db.dialect)

    prompt = ChatPromptTemplate.from_template(template)
  
    llm = ChatGoogleGenerativeAI(model="gemini-2.0-flash", temperature=0)
  
    def get_schema(_):
        return db.get_table_info()
  
    return (
        RunnablePassthrough.assign(schema=get_schema)
        | prompt
        | llm
        | StrOutputParser()
    )
    
def get_response(user_query: str, db: SQLDatabase, chat_history: list):
    sql_chain = get_sql_chain(db)
  
    template = """
    You are an agent designed to interact with a SQL database.
    Given an input question, create a syntactically correct {dialect} query to run, then look at the results of the query and return the answer.

    Never query for all the columns from a specific table, only ask for the relevant columns given the question.


    DO NOT make any DML statements (INSERT, UPDATE, DELETE, DROP etc.) to the
    database.

    To start you should ALWAYS look at the tables in the database to see what you
    can query. Do NOT skip this step.

    Then you should query the schema of the most relevant tables.
    """.format(dialect=db.dialect)
  
    prompt = ChatPromptTemplate.from_template(template)
  
    llm = ChatGoogleGenerativeAI(model="gemini-2.0-flash", temperature=0)
  
    chain = (
        RunnablePassthrough.assign(query=sql_chain).assign(
            schema=lambda _: db.get_table_info(),
            response=lambda vars: db.run(vars["query"]),
        )
        | prompt
        | llm
        | StrOutputParser()
    )
  
    return chain.invoke({
        "question": user_query,
        "chat_history": chat_history,
    })

# Initialize chat history
if "chat_history" not in st.session_state:
    st.session_state.chat_history = [
        AIMessage(content="Hello! I'm a SQL assistant. Ask me anything about your database."),
    ]

load_dotenv()

st.set_page_config(page_title="Chat with SQL Assitant", page_icon=":speech_balloon:")

st.title("Chat with SQL Assitant")

# Directly use specified PostgreSQL credentials
db = init_database("root", "Kitsune#sql98", "localhost", "bank_data")

st.session_state.db = db
st.success("Connected to database!")

for message in st.session_state.chat_history:
    if isinstance(message, AIMessage):
        with st.chat_message("AI"):
            st.markdown(message.content)
    elif isinstance(message, HumanMessage):
        with st.chat_message("Human"):
            st.markdown(message.content)

user_query = st.chat_input("Type a message...")
if user_query is not None and user_query.strip() != "":
    
    with st.chat_message("Human"):
        st.markdown(user_query)
        
    with st.chat_message("AI"):
        response = get_response(user_query, st.session_state.db, st.session_state.chat_history)
        st.markdown(response)
        
    st.session_state.chat_history.append(AIMessage(content=response))