import 'package:flutter/material.dart';

class TasksList extends StatelessWidget {
  final List<dynamic>? tasks;

  TasksList(this.tasks);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 450,
      child: tasks!.isEmpty
          ? Column(
        children: <Widget>[
          Text(
            'No tasks added yet!',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(
            height: 20,
          ),
        ],
      )
          :Column(
          children: [
            Text(
              'All Tasks',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Expanded(
              child:
              ListView.builder(
                itemBuilder: (ctx, index) {
                  return Card(
                    elevation: 5,
                    margin: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 30,
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 40,
                        child: Padding(
                          padding: EdgeInsets.all(6),
                          child: FittedBox(
                            child: Text('${tasks![index]['tag']}'),
                          ),
                        ),
                      ),
                      title: Text(
                        "${tasks![index]['date']}\n${tasks![index]['from']}-${tasks![index]['to']}",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      subtitle: Text(
                        "${tasks![index]['description']}",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                  );},
                itemCount: tasks!.length,
              ),
            ),
      ]),
    );
  }
}