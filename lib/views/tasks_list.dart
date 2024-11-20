import 'package:flutter/material.dart';
import 'package:time_management_ase456/util/database_functions.dart';

class TasksList extends StatefulWidget {
  final List<dynamic>? tasks;

  TasksList(this.tasks);

  @override
  State<TasksList> createState() => _TasksListState();
}
class _TasksListState extends State<TasksList> {

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 450,
      child: widget.tasks!.isEmpty
          ? Column(
        children: <Widget>[
          Text(
            'No tasks added yet!',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      )
          :Column(
          children: [
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
                        radius: 20,
                        child: Padding(
                          padding: EdgeInsets.all(4),
                          child: FittedBox(
                            child: Text('${widget.tasks![index]['tag']}', style:Theme.of(context).textTheme.titleSmall,),
                          ),
                        ),
                      ),
                      title: Text(
                        "${widget.tasks![index]['date']}\n${widget.tasks![index]['from']}-${widget.tasks![index]['to']}",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      subtitle: Text(
                        "${widget.tasks![index]['description']}",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      trailing: IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed:() {
                        deleteTask(widget.tasks![index]['id']).then((_) {
                        setState(() {
                          widget.tasks!.removeAt(index);
                        });
                        });
                        },
                      ),
                    ),
                  );
                },
                itemCount: widget.tasks!.length,
              ),
            ),
          ],
      ),
    );
  }
}