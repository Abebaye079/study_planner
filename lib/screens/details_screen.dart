import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import '../bloc/task_state.dart';
import '../models/task.dart';
import '../widgets/custom_text_field.dart';

class DetailsScreen extends StatefulWidget {
  final Task task;

  const DetailsScreen({
    super.key,
    required this.task,
  });

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  bool _isEditing = false;
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _subjectController;
  late TextEditingController _topicController;
  late TextEditingController _dueDateController;
  late String _selectedPriority;

  final List<String> _priorities = ['High', 'Medium', 'Low'];

  @override
  void initState() {
    super.initState();
    _subjectController =
        TextEditingController(text: widget.task.subject);
    _topicController =
        TextEditingController(text: widget.task.topic);
    _dueDateController =
        TextEditingController(text: widget.task.dueDate);
    _selectedPriority = widget.task.priority;
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _topicController.dispose();
    _dueDateController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF1565C0),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dueDateController.text =
            '${picked.day}/${picked.month}/${picked.year}';
      });
    }
  }

  void _toggleEdit() {
    setState(() => _isEditing = !_isEditing);
  }

  void _saveEdit() {
    if (_formKey.currentState!.validate()) {
      final updatedTask = widget.task.copyWith(
        subject: _subjectController.text.trim(),
        topic: _topicController.text.trim(),
        dueDate: _dueDateController.text.trim(),
        priority: _selectedPriority,
      );
      context.read<TaskBloc>().add(UpdateTask(updatedTask));
    }
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Delete Task',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF1565C0),
          ),
        ),
        content: const Text(
          'Are you sure you want to delete this task?',
          style: TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text(
              'No',
              style: TextStyle(
                color: Color(0xFF1565C0),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context
                  .read<TaskBloc>()
                  .add(DeleteTask(widget.task.id));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Yes',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0),
        elevation: 0,
        title: Text(
          _isEditing ? 'Edit Task' : 'Task Details',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocListener<TaskBloc, TaskState>(
        listener: (context, state) {
          if (state is TaskActionSuccess) {
            if (state.message.contains('updated')) {
              setState(() => _isEditing = false);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Task updated successfully!'),
                  backgroundColor: Color(0xFF1565C0),
                  duration: Duration(seconds: 2),
                ),
              );
            }
            if (state.message.contains('deleted')) {
              Navigator.pop(context, 'deleted');
            }
          }
          if (state is TaskError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // Status Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: widget.task.isCompleted
                        ? Colors.green.withOpacity(0.1)
                        : const Color(0xFF1565C0).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: widget.task.isCompleted
                          ? Colors.green.withOpacity(0.3)
                          : const Color(0xFF1565C0).withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        widget.task.isCompleted
                            ? Icons.check_circle
                            : Icons.pending,
                        color: widget.task.isCompleted
                            ? Colors.green
                            : const Color(0xFF1565C0),
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.task.isCompleted
                                ? 'Completed'
                                : 'In Progress',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: widget.task.isCompleted
                                  ? Colors.green
                                  : const Color(0xFF1565C0),
                            ),
                          ),
                          Text(
                            widget.task.isCompleted
                                ? 'Great job finishing this task!'
                                : 'Keep going, you can do it!',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                if (!_isEditing) ...[
                  _buildInfoRow(Icons.school, 'Subject',
                      widget.task.subject),
                  _buildInfoRow(Icons.topic, 'Topic',
                      widget.task.topic),
                  _buildInfoRow(Icons.calendar_today, 'Due Date',
                      widget.task.dueDate),

                  _buildInfoRow(
                    Icons.flag,
                    'Priority',
                    widget.task.priority,
                    valueColor: _getPriorityColor(widget.task.priority),
                  ),

                  const SizedBox(height: 32),

                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _toggleEdit,
                          icon: const Icon(Icons.edit,
                              color: Colors.white, size: 18),
                          label: const Text(
                            'Edit',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1565C0),
                            padding: const EdgeInsets.symmetric(
                                vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _confirmDelete,
                          icon: const Icon(Icons.delete,
                              color: Colors.white, size: 18),
                          label: const Text(
                            'Delete',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(
                                vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],

                // Edit Mode
                if (_isEditing) ...[
                  CustomTextField(
                    label: 'Subject',
                    hint: 'e.g. Mathematics',
                    icon: Icons.school,
                    controller: _subjectController,
                    validator: (value) =>
                        value!.isEmpty ? 'Subject is required' : null,
                  ),
                  CustomTextField(
                    label: 'Topic',
                    hint: 'e.g. Chapter 3 - Calculus',
                    icon: Icons.topic,
                    controller: _topicController,
                    validator: (value) =>
                        value!.isEmpty ? 'Topic is required' : null,
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.calendar_today,
                              size: 16, color: Color(0xFF1565C0)),
                          SizedBox(width: 6),
                          Text(
                            'Due Date',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1565C0),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _dueDateController,
                        readOnly: true,
                        onTap: _pickDate,
                        validator: (value) => value!.isEmpty
                            ? 'Due date is required'
                            : null,
                        decoration: InputDecoration(
                          hintText: 'Select a due date',
                          hintStyle: TextStyle(
                              color: Colors.grey[400], fontSize: 14),
                          filled: true,
                          fillColor: Colors.grey[50],
                          suffixIcon: const Icon(
                            Icons.calendar_month,
                            color: Color(0xFF1565C0),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: Colors.grey[300]!),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: Color(0xFF1565C0), width: 2),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                const BorderSide(color: Colors.red),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.flag,
                              size: 16, color: Color(0xFF1565C0)),
                          SizedBox(width: 6),
                          Text(
                            'Priority',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1565C0),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: _priorities.map((priority) {
                          final isSelected =
                              _selectedPriority == priority;
                          Color color;
                          switch (priority) {
                            case 'High':
                              color = Colors.red;
                              break;
                            case 'Medium':
                              color = Colors.orange;
                              break;
                            default:
                              color = Colors.green;
                          }
                          return Expanded(
                            child: GestureDetector(
                              onTap: () => setState(
                                  () => _selectedPriority = priority),
                              child: Container(
                                margin: const EdgeInsets.only(right: 8),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? color.withOpacity(0.15)
                                      : Colors.grey[100],
                                  borderRadius:
                                      BorderRadius.circular(10),
                                  border: Border.all(
                                    color: isSelected
                                        ? color
                                        : Colors.grey[300]!,
                                    width: isSelected ? 2 : 1,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    priority,
                                    style: TextStyle(
                                      color: isSelected
                                          ? color
                                          : Colors.grey[600],
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _toggleEdit,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 14),
                            side: const BorderSide(
                                color: Color(0xFF1565C0)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              color: Color(0xFF1565C0),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: BlocBuilder<TaskBloc, TaskState>(
                          builder: (context, state) {
                            return ElevatedButton(
                              onPressed: state is TaskLoading
                                  ? null
                                  : _saveEdit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color(0xFF1565C0),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(12),
                                ),
                              ),
                              child: state is TaskLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    )
                                  : const Text(
                                      'Save Changes',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value, {
    Color? valueColor,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: const Color(0xFF1565C0)),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[500],
                ),
              ),
              Text(
                value.isNotEmpty ? value : 'Not set',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: valueColor ?? Colors.grey[800],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}