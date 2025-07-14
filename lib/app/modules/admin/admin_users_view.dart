import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdminUsersView extends StatefulWidget {
  const AdminUsersView({Key? key}) : super(key: key);

  @override
  State<AdminUsersView> createState() => _AdminUsersViewState();
}

class _AdminUsersViewState extends State<AdminUsersView> {
  final List<Map<String, dynamic>> _users = [
    {'id': 1, 'name': 'John Doe', 'email': 'john@example.com', 'role': 'Customer'},
    {'id': 2, 'name': 'Jane Smith', 'email': 'jane@example.com', 'role': 'Customer'},
    {'id': 3, 'name': 'Admin User', 'email': 'admin@example.com', 'role': 'Admin'},
  ];
  
  List<Map<String, dynamic>> get users => _users;

  void _showUserDialog({Map<String, dynamic>? initial, int? editIndex}) {
    final nameController = TextEditingController(text: initial?['name'] ?? '');
    final emailController = TextEditingController(text: initial?['email'] ?? '');
    String selectedRole = initial?['role'] ?? 'Customer';
    final isEdit = editIndex != null;
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(editIndex == null ? 'Add User' : 'Edit User'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!isEdit) ...[
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(hintText: 'Name'),
                  ),
                  16.verticalSpace,
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(hintText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  16.verticalSpace,
                ],
                DropdownButtonFormField<String>(
                  value: selectedRole,
                  items: ['Customer', 'Admin'].map((role) => DropdownMenuItem(
                    value: role,
                    child: Text(role),
                  )).toList(),
                  onChanged: (val) => setDialogState(() => selectedRole = val ?? selectedRole),
                  decoration: const InputDecoration(hintText: 'Role'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (isEdit) {
                  setState(() {
                    _users[editIndex!] = {
                      'id': _users[editIndex!]['id'],
                      'name': _users[editIndex!]['name'],
                      'email': _users[editIndex!]['email'],
                      'role': selectedRole,
                    };
                  });
                  Navigator.pop(context);
                } else {
                  final name = nameController.text.trim();
                  final email = emailController.text.trim();
                  if (name.isNotEmpty && email.isNotEmpty) {
                    setState(() {
                      _users.add({
                        'id': _users.length + 1,
                        'name': name, 
                        'email': email,
                        'role': selectedRole,
                      });
                    });
                    Navigator.pop(context);
                  }
                }
              },
              child: Text(editIndex == null ? 'Add' : 'Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteUser(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete User'),
        content: const Text('Are you sure you want to delete this user?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _users.removeAt(index);
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'Admin':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Users', style: theme.textTheme.displaySmall),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: _users.length,
                separatorBuilder: (_, __) => SizedBox(height: 16.h),
                itemBuilder: (context, index) {
                  final user = _users[index];
                  return Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: theme.dividerColor),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: _getRoleColor(user['role']).withOpacity(0.1),
                          child: Icon(Icons.person, color: _getRoleColor(user['role'])),
                        ),
                        16.horizontalSpace,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(user['name'], style: theme.textTheme.titleMedium),
                              4.verticalSpace,
                              Text(user['email'], style: theme.textTheme.bodySmall),
                              4.verticalSpace,
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                decoration: BoxDecoration(
                                  color: _getRoleColor(user['role']).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(color: _getRoleColor(user['role'])),
                                ),
                                child: Text(
                                  user['role'],
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: _getRoleColor(user['role']),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.edit, color: theme.primaryColor),
                          onPressed: () => _showUserDialog(initial: user, editIndex: index),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteUser(index),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            24.verticalSpace,
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showUserDialog(),
                icon: Icon(Icons.add),
                label: Text('Add User'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 