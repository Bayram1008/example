import 'package:flutter/material.dart';

class TimesheetApp extends StatelessWidget {
  const TimesheetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return TimesheetScreen();
  }
}

class TimesheetScreen extends StatefulWidget {
  const TimesheetScreen({super.key});

  @override
  _TimesheetScreenState createState() => _TimesheetScreenState();
}

class _TimesheetScreenState extends State<TimesheetScreen> {
  final List<Map<String, String>> _timesheet = List.generate(
    50,
        (index) => {
      'name': 'Employee $index',
      'monday': '',
      'tuesday': '',
      'wednesday': '',
      'thursday': '',
      'friday': '',
      'saturday' : '',
      'sunday' : '',
    },
  );

  void _addNewEmployee() {
    setState(() {
      _timesheet.add({
        'name': 'Employee ${_timesheet.length}',
        'monday': '',
        'tuesday': '',
        'wednesday': '',
        'thursday': '',
        'friday': '',
        'saturday' : '',
        'sunday' : '',
      });
    });
  }

  void _deleteEmployee(int index) {
    setState(() {
      _timesheet.removeAt(index);
    });
  }

  Widget _buildEditableCell(Map<String, String> employee, String day) {
    return TextField(
      onChanged: (value) {
        setState(() {
          employee[day] = value;
        });
      },
      controller: TextEditingController(text: employee[day]),
      decoration: InputDecoration(border: OutlineInputBorder()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Timesheet'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _addNewEmployee,
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: DataTable(
            columns: [
              DataColumn(label: Text('Name')),
              DataColumn(label: Text('Monday')),
              DataColumn(label: Text('Tuesday')),
              DataColumn(label: Text('Wednesday')),
              DataColumn(label: Text('Thursday')),
              DataColumn(label: Text('Friday')),
              DataColumn(label: Text('Saturday')),
              DataColumn(label: Text('Sunday')),
              DataColumn(label: Text('Actions')),
            ],
            rows: _timesheet
                .asMap()
                .entries
                .map(
                  (entry) => DataRow(cells: [
                DataCell(Text(entry.value['name']!)),
                DataCell(_buildEditableCell(entry.value, 'monday')),
                DataCell(_buildEditableCell(entry.value, 'tuesday')),
                DataCell(_buildEditableCell(entry.value, 'wednesday')),
                DataCell(_buildEditableCell(entry.value, 'thursday')),
                DataCell(_buildEditableCell(entry.value, 'friday')),
                DataCell(_buildEditableCell(entry.value, 'saturday')),
                DataCell(_buildEditableCell(entry.value, 'sunday')),
                DataCell(
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _deleteEmployee(entry.key),
                  ),
                ),
              ]),
            )
                .toList(),
          ),
        ),
      ),
    );
  }
}