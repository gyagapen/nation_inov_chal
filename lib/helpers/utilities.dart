import 'dart:io';

bool isNumeric(String s) {
  if(s == null) {
    return false;
  }
  return double.parse(s, (e) => null) != null;
}

void deleteFile(String filePath)
{
  try{
    if(filePath != ""){
      var dir = new Directory(filePath);
      dir.deleteSync(recursive: true);
    }
  } catch(ex){
    
  }
}