import asyncio

async def read_line(file):
    return file.readline();

async def copy_file_async(f_from, f_to):
    with open(f_from, "r") as readfile, open(f_to, 'w') as writefile:
        line = await read_line(readfile)
        while line:
            line_future = read_line(readfile)
            writefile.write(line)
            line = await line_future

asyncio.run(copy_file_async("input.txt", "output.txt"))
