

from fastapi import FastAPI,Response
from fastapi.responses import PlainTextResponse,JSONResponse
import os
import uvicorn
import logging
import random

logging.basicConfig(
    filename= "app.log",
    level=logging.DEBUG,
    format='%(asctime)s %(levelname)s %(module)s:%(lineno)d [SAMPLE_API_MSG]: %(message)s'
)

app = FastAPI()


@app.get('/ping', response_class=JSONResponse)
async def main_ping():
    return JSONResponse(status_code=200, content={"status":"working"})


@app.get('/genlogs', response_class=JSONResponse)
async def generate_logs():
    random_number = random.randint(1, 100)
    # print(random_number)
    if random_number<20:
        logging.info(f'[API_LOG] this is the number {random_number}')
    elif 20>random_number<40:
        logging.debug(f'[API_LOG] this is the number {random_number}')
    elif 40>random_number<60:
        logging.warning(f'[API_LOG] this is the number {random_number}')
    elif 60>random_number<80:
        logging.critical(f'[API_LOG] this is the number {random_number}')
    else:
        logging.error(f'[API_LOG] this is the number {random_number}')
    return JSONResponse(status_code=200, content={"status":"generated logs"})

if __name__ == "__main__":
    uvicorn.run("app:app", host="0.0.0.0", port=5010, reload=True)
