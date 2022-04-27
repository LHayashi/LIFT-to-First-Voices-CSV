from multiprocessing.sharedctypes import Value
import PySimpleGUI as sg

import subprocess
import sys
#sys.path.append("C:/Program Files/Saxonica/SaxonC HE 11.1/Saxon.C.API/python-saxon")
#from saxonc import *
from json import (load as jsonload, dump as jsondump)
from os import path

# Two imports for the zipfile, I am not sure how these interact with the other imports
import zipfile
import os

#import for today's date on Settings Tab
from datetime import date

#Testing path finder
from tkinter import filedialog
"""
    A simple "settings" implementation.  Load/Edit/Save settings for your programs
    Uses json file format which makes it trivial to integrate into a Python program.  If you can
    put your data into a dictionary, you can save it as a settings file.
    
    Note that it attempts to use a lookup dictionary to convert from the settings file to keys used in 
    your settings window.  Some element's "update" methods may not work correctly for some elements.
    
    Copyright 2020 PySimpleGUI.com
    Licensed under LGPL-3
"""

SETTINGS_FILE = path.join(path.dirname(__file__), r'settings_file.cfg')
DEFAULT_SETTINGS = {'FWDATA_file': 10, 'LIFT_file': None , 'transform_file': None, 'output_folder' : None, 'saxon_jar': None,'from_date': None, 'to_date': None}
# "Map" from the settings dictionary keys to the window's element keys
SETTINGS_KEYS_TO_ELEMENT_KEYS = {'FWDATA_file': '-FWDATA_file-', 'LIFT_file': '-LIFT_file-' , 'transform_file': '-transform_file-', 'output_folder' : '-output_folder-', 'saxon_jar' : '-saxon_jar-', 'from_date' : '-from_date-', 'to_date' : '-to_date-'}


########################################## Load/Save Settings File ##########################################
def load_settings(settings_file, default_settings):
    try:
        with open(settings_file, 'r') as f:
            settings = jsonload(f)
    except Exception as e:
        sg.popup_quick_message(f'exception {e}', 'No settings file found... will create one for you', keep_on_top=True, background_color='red', text_color='white')
        settings = default_settings
        save_settings(settings_file, settings, None)
    return settings


def save_settings(settings_file, settings, values):
    if values:      # if there are stuff specified by another window, fill in those values
        for key in SETTINGS_KEYS_TO_ELEMENT_KEYS:  # update window with the values read from settings file
            try:
                settings[key] = values[SETTINGS_KEYS_TO_ELEMENT_KEYS[key]]
            except Exception as e:
                print(f'Problem updating settings from window values. Key = {key}')

    with open(settings_file, 'w') as f:
        jsondump(settings, f)

    #sg.popup('Settings saved')

#####################Create a Zip File function ##########################

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

########################################## Make a Transform window ##########################################
def create_transform_window(settings):
    sg.theme('Light Blue 2')

    #TextLabel is used below.
    def TextLabel(text): return sg.Text(text+':', justification='l', size=(20,1))

    layout1 = [
        [sg.Text('\nIn FieldWorks, please do each of the steps below:', font='Any 12')],
        [sg.Checkbox('1. Do a send and receive')],
        [sg.Image(filename='SendReceive_small.png', key='image', size=(150,100)), sg.Button('Expand Photo')],
        [sg.Checkbox('2. Clean up data')],
        [sg.Checkbox('3. Turn off all filters')],
        [sg.Checkbox('4. "Sort" by head word')],
        [sg.Checkbox('5. Filter by publication')],
        [sg.Checkbox('6. Add filter for date modified, see "Exports" tab for last export date')], #add the date of last export from layout 2 here
        [sg.Checkbox('7. File ... Export ... ')], 
        [sg.Image(filename='ExportLIFT_small.png', key='image', size=(150,100)), sg.Button('Expand Photo')],
    ]

    layout2 = [
        [sg.Text('\nLog of previous exports:', font='Any 12')],
        [sg.Output(key='-logs-', size=(80, 20))]
    ]


    layout3 = [
        [sg.Text('\nChange relevant settings first.', font='Any 12')],
        [sg.Text('\nBe sure to check the date.', font='Any 12')],
        [TextLabel('FieldWorks database file'), sg.Input(key='-FWDATA_file-'), sg.FileBrowse(target='-FWDATA_file-', file_types = (("fwdata", "*.fwdata"), ),)],
        [TextLabel('Exported LIFT file'),sg.Input(key='-LIFT_file-', enable_events=True), sg.FileBrowse(target='-LIFT_file-', file_types = (("LIFT", "*.lift"), ),)],
        [TextLabel('FirstVoices CSV folder'), sg.Input(key='-output_folder-', tooltip="Choose where you would like your .csv files to go"), sg.FolderBrowse(target='-output_folder-',)],
        [TextLabel('LIFT2FirstVoices XSL file'),sg.Input(key='-transform_file-'), sg.FileBrowse(target='-transform_file-', file_types = (("XSLT", "*.xsl"), ),)],
        [TextLabel('Saxon transform.jar file'),sg.Input(key='-saxon_jar-'), sg.FileBrowse(target='-saxon_jar-', file_types = (("JAR", "*.jar"), ),)],
        [TextLabel('Export entries since'),sg.Input(key='-from_date-'), sg.CalendarButton('Choose Date', target='-from_date-', format="%Y-%m-%d")],
        [TextLabel("and up to"), sg.Input(key='-to_date-'), sg.CalendarButton('Choose Date', target='-to_date-', format="%Y-%m-%d")],

        [sg.Button('Save Settings'), sg.Button('Exit')]
    ]

    layout4 = [
        [sg.Text('\nTransform LIFT to First Voices', font='Any 12')],
        [sg.Button('Transform LIFT to FirstVoices')]
    ]

    layout5 = [
        [sg.Text("\nLet's ZIP your files!", font='Any 12')],
        [sg.Text("Upload your Audio and Image files below")],
        [TextLabel('Audio folder'), sg.Input(key='-audio_folder-'), sg.FolderBrowse()],
        [TextLabel('Images folder'), sg.Input(key='-image_folder-'), sg.FolderBrowse()],
        [sg.Button('ZIP Files')]
    ]

    layout6 = [
        [sg.Text("\nAnd you're done!\n", font='Any 12')],
        #[sg.Text('Date of Last Export:'), sg.Input(key='-override_date-'), sg.Button('Today'), sg.CalendarButton('Override', target='-override_date-', format="%Y-%m-%d")],
        # [sg.Text('Type of Export:'), sg.Checkbox('New', default=True, key='-export_type_new-'), sg.Checkbox('Modified', default=True, key='-export_type_modified-')],
        [sg.Text('Double check that your dates are accurate in the Settings tab, then click below:\n')],
        [sg.Button('Record to Export Log')]


        #[sg.Text('Date of Last Export:'), sg.Text(date.today()), sg.Button('Today')],
        #[sg.Text('If Date of Last Export was not today:'), sg.Input(key='-override_date-'), sg.CalendarButton('Override', target='-override_date-', format="%Y-%m-%dT%H:%M:00Z")]

        # add field underneath showing date and manual override calendar
    ]

    tab_group = [
        [sg.TabGroup([
            [
                sg.Tab('Clean up & Instructions', layout1, title_color='Black'),
                sg.Tab('Exports', layout2, title_color='Black', key='tab_export'),
                sg.Tab('Settings', layout3, title_color='Black', key='tab_settings'),
                sg.Tab('LIFT to FV', layout4, title_color='Black'),
                sg.Tab('Zip Files', layout5, title_color='Black'),
                sg.Tab('Finish', layout6, title_color='Black')
            ]
        ], key='tab_group', enable_events=True, tab_location='topleft', title_color='Black', tab_background_color='Gray',
            selected_title_color='White', selected_background_color='Gray', border_width=0)]
    ]

    window = sg.Window('FieldWorks LIFT to First Voices', tab_group, size=(700, 500), keep_on_top=True, finalize=True)

    for key in SETTINGS_KEYS_TO_ELEMENT_KEYS:   # update window with the values read from settings file
        try:
            window[SETTINGS_KEYS_TO_ELEMENT_KEYS[key]].update(value=settings[key])
        except Exception as e:
            print(f'Problem updating PySimpleGUI window from settings. Key = {key}')

    return window


########################################## Make a settings window ##########################################
def create_settings_window(settings):
    sg.theme('Light Blue 2')

    #TextLabel is used below.
    def TextLabel(text): return sg.Text(text+':', justification='l', size=(17,1))

    # layout = [  [sg.Text('Lex Clean File Settings', font='Any 15')],
    #             [TextLabel('FieldWorks database file'), sg.Input(key='-FWDATA_file-'), sg.FileBrowse(target='-FWDATA_file-', file_types = (("fwdata", "*.fwdata"), ))],
    #             [TextLabel('Exported LIFT file'),sg.Input(key='-LIFT_file-'), sg.FileBrowse(target='-LIFT_file-', file_types = (("LIFT", "*.lift"), ))],
    #             [TextLabel('FirstVoices CSV file'),sg.Input(key='-output_folder-'), sg.FileBrowse(target='-output_folder-')],
    #             [TextLabel('LIFT2FirstVoices XSL file'),sg.Input(key='-transform_file-'), sg.FileBrowse(target='-transform_file-', file_types = (("XSLT", "*.xsl"), ))],
    #             [TextLabel('Saxon transform.jar file'),sg.Input(key='-saxon_jar-'), sg.FileBrowse(target='-saxon_jar-', file_types = (("JAR", "*.jar"), ))],
    #             [TextLabel('Date of last export'),sg.Input(key='-last_date-'), sg.CalendarButton('Choose Date', target='-last_date-', format="%Y-%m-%dT%H:%M:00Z")],
    #             [sg.Button('Save Settings'), sg.Button('Cancel')]  ]


    window = sg.Window('Settings', layout, size=(600, 300), keep_on_top=True, finalize=True)

    for key in SETTINGS_KEYS_TO_ELEMENT_KEYS:   # update window with the values read from settings file
        try:
            window[SETTINGS_KEYS_TO_ELEMENT_KEYS[key]].update(value=settings[key])
        except Exception as e:
            print(f'Problem updating PySimpleGUI window from settings. Key = {key}')

    return window

########### Testing finding a path #########

#def search_for_file_path ():
#
#    currdir = os.getcwd()
#    tempdir = filedialog.askdirectory(parent=root, initialdir=currdir, title='Please select a directory')
#    if len(tempdir) > 0:
#        print ("You chose: %s" % tempdir)

#    return tempdir


########################################## Main Program Window & Event Loop ##########################################
# def create_main_window(settings):
#     sg.theme('Light Blue 2')
#
#     layout = [[sg.T('This is my main application')],
#               [sg.T('Add your primary window stuff in here')],
#               [sg.B('Transform'), sg.B('Exit'), sg.B('Change Settings')]]
#
#     return sg.Window('FieldWorks LIFT to FirstVoices CSV', layout)


def main():
    window, settings = None, load_settings(SETTINGS_FILE, DEFAULT_SETTINGS )


    while True:             # Event Loop
        if window is None:
            #window = create_main_window(settings)
            window = create_transform_window(settings)

        event, values = window.read()
        print(event)
        if event in (None, 'Exit'):
            break

        if event == 'tab_group':
            active_tab = values['tab_group']
            if active_tab == 'tab_export':
                file = open('logs.txt', 'r')
                window['-logs-'].update(value=file.read())
                file.close()

        # if event == 'tab_group':
        #     active_tab = values['tab_group']
        #     if active_tab == 'tab_settings':
        #         pathlift = os.path.dirname(os.path.abspath(values['-LIFT_file-']))
        #         pathoutput = values['-output_folder-']
        #         pathfieldworks = os.path.dirname(os.path.abspath(values['-LIFT_file-']))

        # if event == '-LIFT_file-':
        #     new_file_name = values['-LIFT_file-']
        #     # new_file_name = (new_file_name[:-5]) + '/FirstVoices'
        #     os.mkdir('FirstVoices')
        #     new_folder = os.path.abspath('FirstVoices')
        #     window['-output_folder-'].update(value=new_folder)

        #if event ==


        if event == 'Save Settings':
            save_settings(SETTINGS_FILE, settings, values)
        #if event == 'Change Settings':
            #event, values = create_settings_window(settings).read(close=True)
            #if event == 'Save Settings':
                #window.close()
                #window = None
                #save_settings(SETTINGS_FILE, settings, values)

        if event == 'Expand Photo':
            sg.popup_no_buttons(title='Send Receive', keep_on_top=True, image='SendReceive_large.png')

        if event == 'Transform':
            event, values = create_transform_window(settings).read(close=True)
            # if event == 'Transform LIFT to FirstVoices':
            #      #input = "C:/Users/Larry/Desktop/OxygenXMLGradingProject/DesktopLIFT/DesktopLIFT.lift"
            #      input = values['-LIFT_file-']
            #      output = values['-output_folder-']
            #      xslt = values['-transform_file-']
            #      lastdate = values['-last_date-']
            #      subprocess.call(f"java -cp C:\SaxonHE11-1J\saxon-he-11.1.jar net.sf.saxon.Transform -t -s:{input} -xsl:{xslt} -o:{output} pLIFTfile={input} pLastDateExport={lastdate}")
            #      window.close()
            #      window = None
            #      #save_settings(SETTINGS_FILE, settings, values)
            #      sg.popup('Transformation successful!')
        if event == 'Transform LIFT to FirstVoices':
            #input = "C:/Users/Larry/Desktop/OxygenXMLGradingProject/DesktopLIFT/DesktopLIFT.lift"
            input = values['-LIFT_file-']
            output = values['-output_folder-']
            outputnew = output+'/NewEntries.csv'
            outputmodified = output+'/ModifiedEntries.csv'
            xslt = values['-transform_file-']
            fromdate = values['-from_date-']
            todate = values['-to_date-']
            save_settings(SETTINGS_FILE, settings, values)
            subprocess.call(f"java -cp C:\SaxonHE11-1J\saxon-he-11.1.jar net.sf.saxon.Transform -t -s:{input} -xsl:{xslt} -o:{outputnew}  pLIFTfile={input} pDateFrom={fromdate} pDateTo={todate} pExportMode='new'")
            subprocess.call(f"java -cp C:\SaxonHE11-1J\saxon-he-11.1.jar net.sf.saxon.Transform -t -s:{input} -xsl:{xslt} -o:{outputmodified} pLIFTfile={input} pDateFrom={fromdate} pDateTo={todate} pExportMode='modified'")
            window.close()
            window = None
            save_settings(SETTINGS_FILE, settings, values)
            sg.popup('Transformation successful!')

        if event == 'ZIP Files':
            input = values['-audio_folder-']
            prepare_zip(input)
            input = values['-image_folder-']
            prepare_zip(input)
            window.close()
            window = None
            sg.popup('Successfully zipped!')

        if event == 'Today':
            window['-override_date-'].update(value=date.today())

        if event == 'Record to Export Log':
            file = open('logs.txt', 'a+')
            firstdate = values['-from_date-']
            seconddate = values['-to_date-']
            file.write(f'{date.today()}: Exported new and modified entries between {firstdate} and {seconddate}\n')
            file.close()
            sg.popup('Successfully added to Exports Log!', keep_on_top=True)



#### When we had radio buttons###
        #export_date = values['-override_date-']
        # if values['-export_type_new-'] is True and values['-export_type_modified-'] is True:
        #     file.write(f'{export_date}: Exported new and modified entries\n')
        # elif values['-export_type_new-'] is True:
        #     file.write(f'{export_date}: Exported new entries\n')
        # elif values['-export_type_modified-'] is True:
        #     file.write(f'{export_date}: Exported modified entries\n')
        # else:
        #     file.write(f'{export_date}: Exported new and modified entries\n')


        #if event == '[-FWDATA_file-]':
        #    file_path_variable = search_for_file_path()
        #    print("\nfile_path_variable = ", file_path_variable)



    window.close()
main()



# sg.theme('Light Blue 2')

# layout = [[sg.Text('Select the files below')],
#           [sg.Text('FLEx Database', size=(12, 1)), sg.Input(), sg.FileBrowse()],
#           [sg.Text('LIFT File Export', size=(12, 1)), sg.Input(), sg.FileBrowse()],
#           [sg.Text('Output HTML', size=(12, 1)), sg.Input(), sg.FileBrowse()],
#           [sg.Text('Transformer (XSL)', size=(12, 1)), sg.Input(), sg.FileBrowse()],
#           [sg.Submit(), sg.Cancel()]]

# window = sg.Window('Lex Clean', layout)

# event, values = window.read()
# window.close()
#print(f'You clicked {event}')
#print(f'You chose filenames {values[0]} and {values[1]}')