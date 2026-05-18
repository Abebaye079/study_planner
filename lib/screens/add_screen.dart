import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import '../bloc/task_state.dart';
import '../models/task.dart';
import '../widgets/custom_text_field.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final _formKey = GlobalKey<FormState>();

  final _subjectController = TextEditingController();
  final _topicController = TextEditingController();
  final _dueDateController = TextEditingController();

  String _selectedPriority = 'Medium';
  final List<String> _priorities = ['High', 'Medium', 'Low'];

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

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final task = Task(
        id: 0,
        subject: _subjectController.text.trim(),
        topic: _topicController.text.trim(),
        priority: _selectedPriority,
        dueDate: _dueDateController.text.trim(),
        isCompleted: false,
      );
      context.read<TaskBloc>().add(CreateTask(task));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0),
        elevation: 0,
        title: const Text(
          'Add New Task',
          style: TextStyle(
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
            Navigator.pop(context);
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

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1565C0).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF1565C0).withOpacity(0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.menu_book,
                        color: Color(0xFF1565C0),
                        size: 30,
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Fill in the details for your new study task',
                          style: TextStyle(
                            color: Color(0xFF1565C0),
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

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
                      validator: (value) =>
                          value!.isEmpty ? 'Due date is required' : null,
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
                        final isSelected = _selectedPriority == priority;
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
                            onTap: () =>
                                setState(() => _selectedPriority = priority),
                            child: Container(
                              margin: const EdgeInsets.only(right: 8),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? color.withOpacity(0.15)
                                    : Colors.grey[100],
                                borderRadius: BorderRadius.circular(10),
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

                BlocBuilder<TaskBloc, TaskState>(
                  builder: (context, state) {
                    return SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: state is TaskLoading
                            ? null
                            : _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1565C0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: state is TaskLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              )
                            : const Text(
                                'Add Task',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}