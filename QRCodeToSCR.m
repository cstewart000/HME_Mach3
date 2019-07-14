
#{
QRCordeToSCR.m

Authour: cstewart000@gmail.com
14/07/2019

Script to take a URL and convert to a AutoCAD interpretable script for creating 
QR codes. Script runs a few dialog prompts for inputs and creats a ".scr" file 
which can be run in AutoCAD to create a .dxf for CNC machining.

http://goqr.me/
#}




#Packages
pkg load image;


# Variables

#{
file_out_name = "QRscript.scr"
qr_size = 27;
rad_drill = 0.4
target_url = "https://bit.ly/2NDh5Sn"
#}

# Prompted variables
file_out_name = inputdlg ("output name for AutoCAD script"){1}
qr_size = inputdlg ("Size (in minimum pixels) of QR code - may need to run a couple of times to confirm QR is well formed"){1}
rad_drill = inputdlg ("Enter a value for the radius of the pixel ~0.5"){1}
target_url = inputdlg ("Target URL of the QR code"){1}

#Fixed/global  variables
api_url = "https://api.qrserver.com/v1/create-qr-code/?"
complete_url ="";
fileOut = "";

# build the URL
complete_url = strcat(api_url, "size=", qr_size, "x", qr_size, "&data=", target_url)

#Get QR code online
onlineImg = imread (complete_url); 
figure();
imshow(onlineImg);


btn = questdlg ("Is the QR code well formed", "QR Code formed", "Yes", "No", "No");
if (strcmp (btn, "Yes"))
  #TODO re-run size prompt url build and request 
endif

onlineImg = imcomplement(onlineImg);
onlineImg = im2bw(onlineImg);

#Nested loop through each of the pixels 
for i = 1:SIZE
  for j = 1:SIZE
  
    #If the pixel is false (ie black) add a circle at that point
    if (!onlineImg(i,j))
      
      #add the circle command at the coordinate
      fileOut = strcat(fileOut, "Circle ", "\r\n",  num2str(i),",",num2str(j)," ",num2str(rad_drill), "\r\n");
    endif

  endfor
endfor


#Write the output to file
fid = fopen (fileOutName, "w");
fdisp(fid,fileOut);
fclose(fid);
clear('fileOut');
