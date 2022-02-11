import os
import subprocess

#def file_path(relative_path):
#    folder = os.path.dirname(os.path.abspath(__file__))
#    path_parts = relative_path.split("/")
#    new_path = os.path.join(folder, *path_parts)
#    return new_path

#def transform(xml_file, xsl_file, output_file):
#    """all args take relative paths from Python script"""
    #input = file_path(xml_file)
    #output = file_path(output_file)
    #xslt = file_path(xsl_file)
input = "C:/Users/Larry/Desktop/OxygenXMLGradingProject/DesktopLIFT/DesktopLIFT.lift"
output = "C:/Users/Larry/Desktop/OxygenXMLGradingProject/outputnow.html"
xslt = "C:/Users/Larry/Desktop/OxygenXMLGradingProject/GradingStudentLexicons.xsl"

subprocess.call(f"java -cp C:\SaxonHE11-1J\saxon-he-11.1.jar net.sf.saxon.Transform -t -s:{input} -xsl:{xslt} -o:{output}")