import 'dart:convert';
import 'package:cursoflutter/classes/departmentsModel.dart';
import 'package:cursoflutter/final_pages/categorySelected.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as rootBundle;

class SubDeparments extends StatefulWidget {
   SubDeparments({ required this.nombreDto });
   final String nombreDto;

  @override
  _SubDeparmentsState createState() => _SubDeparmentsState();
} 

class _SubDeparmentsState extends State<SubDeparments> {

  var selectedValue;
  navigateToCategory(String sDepartment, String sSubDeparment, String sCategory){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>
      SelectedCategory(department: sDepartment, subDepartment: sSubDeparment, category: sCategory,)
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.nombreDto), centerTitle: true,),
      body:  FutureBuilder(
      future: ReadJsonData(widget.nombreDto),
      builder: (context, data) {
        if (data.hasError) {
         //in case if error found
          return Center(child: Text("${data.error}"));
        } else if (data.hasData) {
           //once data is ready this else block will execute
          // items will hold all the data of DataModel
           //items[index].name can be used to fetch name of product as done below
          var items = data.data as List<DepartmentModel>;
          return ListView.builder(
              itemCount: items == null ? 0 : items.length,
              itemBuilder: (context, index) {
                 String _vista =items[index].nombre.toString();
                String sDepartment;
                String category;
                return Card(
                  elevation: 5,
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child: Row(children: [Image.network(items[index].imageURL.toString(), width: 50, height:50),
                    SizedBox(width: 15,),
                    Container(
                      width: 300,
                      child: DropdownButtonHideUnderline(child: DropdownButton(isExpanded: true,hint: Text(_vista),value: selectedValue, 
                      icon: Icon(Icons.arrow_drop_down_outlined),
                      onChanged: (_value)=>{
                         sDepartment = _vista,
                         //print(_vista), //Nombre de departamento Ej. Helados y paletas
                          setState(() {
                            _vista=_value.toString();
                          }),
                          category = _vista,
                          //print(_vista), //Helado
                          //Navigator.of(context).push(route)
                          navigateToCategory(widget.nombreDto, sDepartment, category)
                      },
                      items: items[index].subDepts!.map((items1){

                        return DropdownMenuItem(value: items1, child: Text(items1));
                      } ).toList(),
                      )),
                    )])
                  ),
                );
              });
        } else {
              // show circular progress while data is getting fetched from json file
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    ),
    );

  }
  Future<List<DepartmentModel>> ReadJsonData(String Sdept) async {
    //read json file
    
    final jsondata = await rootBundle.rootBundle.loadString('JSONfiles/'+Sdept+'_dept.json');
    //decode json data as list
    final list = json.decode(jsondata) as List<dynamic>;
    
    //map json and initialize using DataModel
    return list.map((e) => DepartmentModel.fromJson(e)).toList();
  }
}