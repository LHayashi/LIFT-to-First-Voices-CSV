import zipfile
import os


def prepare_zip(dir_path):
    new_file = dir_path + '.zip'
    zip = zipfile.ZipFile(new_file, 'w', zipfile.ZIP_DEFLATED)

    for dir_path, dir_names, files in os.walk(dir_path):
        f_path = dir_path.replace(dir_path, '')
        f_path = f_path and f_path + os.sep

        for file in files:
            zip.write(os.path.join(dir_path, file), f_path + file)
    zip.close()
    print("File Created successfully..")
    return new_file


prepare_zip('C:/Users/olivi/Documents/TESTING')