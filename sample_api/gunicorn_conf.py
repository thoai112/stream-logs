from multiprocessing import cpu_count



# Socket Path

bind = 'unix:/opt/logsapi/gunicorn.sock'



# Worker Options

workers = cpu_count() + 1

worker_class = 'uvicorn.workers.UvicornWorker'



# Logging Options

loglevel = 'debug'

accesslog = '/tmp/gunicornlogs/access_log'

errorlog =  '/tmp/gunicornlogs/error_log'