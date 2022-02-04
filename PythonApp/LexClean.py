import PySimpleGUI as sg
from json import (load as jsonload, dump as jsondump)
from os import path

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
DEFAULT_SETTINGS = {'FWDATA_file': 10, 'LIFT_file': None , 'transform_file': sg.theme(), 'output_xhtml' : '94102'}
# "Map" from the settings dictionary keys to the window's element keys
SETTINGS_KEYS_TO_ELEMENT_KEYS = {'FWDATA_file': '-FWDATA_file-', 'LIFT_file': '-LIFT_file-' , 'transform_file': '-transform_file-', 'output_xhtml' : '-output_xhtml-'}

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

    sg.popup('Settings saved')

########################################## Make a settings window ##########################################
def create_settings_window(settings):
    sg.theme('Light Blue 2')

    #TextLabel is used below.
    def TextLabel(text): return sg.Text(text+':', justification='l', size=(17,1))

    layout = [  [sg.Text('Lex Clean File Settings', font='Any 15')],
                [TextLabel('FieldWorks database file'), sg.Input(key='-FWDATA_file-'), sg.FileBrowse(target='-FWDATA_file-', file_types = (("fwdata", "*.fwdata"), ))],
                [TextLabel('Exported LIFT file'),sg.Input(key='-LIFT_file-'), sg.FileBrowse(target='-LIFT_file-', file_types = (("LIFT", "*.lift"), ))],
                [TextLabel('Lex Clean output html'),sg.Input(key='-output_xhtml-'), sg.FileBrowse(target='-output_xhtml-')],
                [TextLabel('Lex Clean transform'),sg.Input(key='-transform_file-'), sg.FileBrowse(target='-transform_file-', file_types = (("XSLT", "*.xsl"), ))],
                [sg.Button('Save'), sg.Button('Cancel')]  ]


    window = sg.Window('Settings', layout, size=(600, 300), keep_on_top=True, finalize=True)

    for key in SETTINGS_KEYS_TO_ELEMENT_KEYS:   # update window with the values read from settings file
        try:
            window[SETTINGS_KEYS_TO_ELEMENT_KEYS[key]].update(value=settings[key])
        except Exception as e:
            print(f'Problem updating PySimpleGUI window from settings. Key = {key}')

    return window

########################################## Main Program Window & Event Loop ##########################################
def create_main_window(settings):
    sg.theme('Light Blue 2')

    layout = [[sg.T('This is my main application')],
              [sg.T('Add your primary window stuff in here')],
              [sg.B('Ok'), sg.B('Exit'), sg.B('Change Settings')]]

    return sg.Window('Main Application', layout)


def main():
    window, settings = None, load_settings(SETTINGS_FILE, DEFAULT_SETTINGS )

    while True:             # Event Loop
        if window is None:
            window = create_main_window(settings)

        event, values = window.read()
        if event in (None, 'Exit'):
            break
        if event == 'Change Settings':
            event, values = create_settings_window(settings).read(close=True)
            if event == 'Save':
                window.close()
                window = None
                save_settings(SETTINGS_FILE, settings, values)
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