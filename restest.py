import psutil
from datetime import datetime
import time
import os

processlist=[]

def find_size(bytes):
    for unit in ['', 'K', 'M', 'G', 'T', 'P']:
        if bytes < 1024:
            return f"{bytes:.2f}{unit}B"
        bytes /= 1024
        
        
def get_processes_info():
    processes = []
    for process in psutil.process_iter():
      
        with process.oneshot():
           
            pid = process.pid
            if pid == 0:
                continue
            name = process.name()
            try:
                create_time = datetime.fromtimestamp(process.create_time())
            except OSError:
                create_time = datetime.fromtimestamp(psutil.boot_time())
            try:
                cores = len(process.cpu_affinity())
            except psutil.AccessDenied:
                cores = 0
            cpu_usage = process.cpu_percent()
            status = process.status()
            try:
                nice = int(process.nice())
            except psutil.AccessDenied:
                nice = 0
            try:
                memory_usage = process.memory_full_info().uss
            except psutil.AccessDenied:
                memory_usage = 0

            #io_counters = process.io_counters()
            #read_bytes = io_counters.read_bytes
            #write_bytes = io_counters.write_bytes
            n_threads = process.num_threads()
            try:
                username = process.username()
            except psutil.AccessDenied:
                username = "N/A"
            
        #processes.append({
        #    'pid': pid, 'name': name, 'create_time': create_time,
        #    'cores': cores, 'cpu_usage': cpu_usage, 'status': status, 'nice': nice,
        #    'memory_usage': memory_usage, 'read_bytes': read_bytes, 'write_bytes': write_bytes,
        #    'n_threads': n_threads, 'username': username,
        #})
        
        processes.append({
            'pid': pid, 'name': name, 'create_time': create_time,'cores': cores, 'cpu_usage': cpu_usage, 'status': status, 'memory_usage': memory_usage, 'n_threads': n_threads
        })


    return processes
    
processlist = get_processes_info()

for process in processlist:
   #print (process)
    
    for key in process:
        if key=="memory_usage":
           print("\t memory_usage = ",find_size(process[key]))
        if key=="memory_usage":
           pass
        else:           
           print('\t {0} = {1}'.format(key,process[key]),end =" ")
    print("\n")
        
