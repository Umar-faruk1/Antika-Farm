import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/models/user_model.dart';

class AdminUsersView extends StatefulWidget {
  const AdminUsersView({Key? key}) : super(key: key);

  @override
  State<AdminUsersView> createState() => _AdminUsersViewState();
}

class _AdminUsersViewState extends State<AdminUsersView> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<UserModel>> _fetchUsers() async {
    final snapshot = await _firestore.collection('users').get();
    return snapshot.docs.map((doc) => UserModel.fromMap(doc.data())).toList();
  }

  Future<void> _updateUserRoleStatus(String uid, String role, String status) async {
    await _firestore.collection('users').doc(uid).update({'role': role, 'status': status});
    setState(() {});
  }

  void _showUserDialog({required UserModel user}) {
    String selectedRole = user.role;
    String selectedStatus = user.status;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('Edit User'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(user.name),
                16.verticalSpace,
                Text(user.email),
                16.verticalSpace,
                DropdownButtonFormField<String>(
                  value: selectedRole,
                  items: ['admin', 'user'].map((role) => DropdownMenuItem(
                    value: role,
                    child: Text(role),
                  )).toList(),
                  onChanged: (val) => setDialogState(() => selectedRole = val ?? selectedRole),
                  decoration: const InputDecoration(hintText: 'Role'),
                ),
                16.verticalSpace,
                DropdownButtonFormField<String>(
                  value: selectedStatus,
                  items: ['active', 'inactive'].map((status) => DropdownMenuItem(
                    value: status,
                    child: Text(status),
                  )).toList(),
                  onChanged: (val) => setDialogState(() => selectedStatus = val ?? selectedStatus),
                  decoration: const InputDecoration(hintText: 'Status'),
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
              onPressed: () async {
                await _updateUserRoleStatus(user.uid, selectedRole, selectedStatus);
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'admin':
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
        child: FutureBuilder<List<UserModel>>(
          future: _fetchUsers(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No users found'));
            }
            final users = snapshot.data!;
            return ListView.separated(
              itemCount: users.length,
              separatorBuilder: (_, __) => SizedBox(height: 16.h),
              itemBuilder: (context, index) {
                final user = users[index];
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
                        backgroundColor: _getRoleColor(user.role).withOpacity(0.1),
                        child: Icon(Icons.person, color: _getRoleColor(user.role)),
                      ),
                      16.horizontalSpace,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(user.name, style: theme.textTheme.titleMedium),
                            4.verticalSpace,
                            Text(user.email, style: theme.textTheme.bodySmall),
                            4.verticalSpace,
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                              decoration: BoxDecoration(
                                color: _getRoleColor(user.role).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(color: _getRoleColor(user.role)),
                              ),
                              child: Text(
                                user.role,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: _getRoleColor(user.role),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            4.verticalSpace,
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                              decoration: BoxDecoration(
                                color: user.status == 'active' ? Colors.green.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(color: user.status == 'active' ? Colors.green : Colors.grey),
                              ),
                              child: Text(
                                user.status,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: user.status == 'active' ? Colors.green : Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.edit, color: theme.primaryColor),
                        onPressed: () => _showUserDialog(user: user),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
} 