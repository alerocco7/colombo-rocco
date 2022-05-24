import 'package:flutter/material.dart';


class HomePage extends StatelessWidget {   
  static const route = 'homepage';
  static const routename = 'Homepage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('HomePage')), 
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(   
                child: Text('To ProfilePage'),            
                onPressed: () {                         
                  Navigator.pushNamed(context, 'profile');           
                  
                }
              ),
              ElevatedButton(  
                child: Text('To CalendarPage'),             
                onPressed: () {                          
                  Navigator.pushNamed(context, 'calendar');          
                  
                }
              ),

              ElevatedButton(  
                child: Text('To NotePage'),             
                onPressed: () {                         
                  Navigator.pushNamed(context, 'note');           
                  
                }
              ),
              
            ],
          ),
        ),
    );
  }
}
