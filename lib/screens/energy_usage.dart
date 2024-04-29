import 'package:flutter/material.dart';

class EnergyUsageCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final primaryGreen = Theme.of(context).primaryColor;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, Colors.grey[100]!],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.battery_full,
                        color: primaryGreen, 
                      ),
                      SizedBox(width: 8.0),
                      Text(
                        'Energy Usage',
                        style: TextStyle(
                          fontSize: 20.0,
                          color: primaryGreen, // Changed to primary green color
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {
                      
                    },
                    icon: Icon(
                      Icons.info_outline,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: Colors.grey, // Changed to grey color
                      ),
                      SizedBox(width: 8.0),
                      UsageColumn(title: 'Today', value: '26.8kWh'),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: Colors.grey, // Changed to grey color
                      ),
                      SizedBox(width: 8.0),
                      UsageColumn(title: 'This Month', value: '325.37kWh'),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Divider(color: Colors.grey),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Last Recharge',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 16.0,
                        ),
                      ),
                      Text(
                        '2 weeks ago',
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      // no action
                    },
                    icon: Icon(Icons.add, color: Colors.white,),
                    label: Text('Battery', style: TextStyle(color: Colors.white),),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryGreen, // Changed to primary green color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UsageColumn extends StatelessWidget {
  final String title;
  final String value;

  const UsageColumn({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 16.0,
          ),
        ),
        SizedBox(height: 8.0),
        Text(
          value,
          style: TextStyle(
            color: Theme.of(context).primaryColor, 
            fontSize: 24.0,
          ),
        ),
      ],
    );
  }
}
