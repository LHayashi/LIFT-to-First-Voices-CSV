import os

dirName = 'FirstVoices'

new_folder = os.path.abspath('FirstVoices')

try:
    os.mkdir(dirName)
    print("Folder", dirName, "Created")

except FileExistsError:
    print("Folder", dirName, "already exists.")

print(new_folder)


########
if event == '-LIFT_file-':
    new_file_name = values['-LIFT_file-']
    # new_file_name = (new_file_name[:-5]) + '/FirstVoices'

    dirName = 'FirstVoices'
    try:
        os.mkdir(dirName)
        new_folder = os.path.abspath('FirstVoices')
        window['-output_xhtml-'].update(value=new_folder)

    except FileExistsError:
        sg.popup('Folder', dirName, 'already exists.')