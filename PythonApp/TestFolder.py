import os

dirName = 'FirstVoices'

new_folder = os.path.abspath('FirstVoices')

try:
    os.mkdir(dirName)
    print("Folder", dirName, "Created")

except FileExistsError:
    print("Folder", dirName, "already exists.")

print(new_folder)
