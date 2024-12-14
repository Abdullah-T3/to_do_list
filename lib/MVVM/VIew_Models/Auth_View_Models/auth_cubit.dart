import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Future<void> close() {
    emailController.dispose();
    passwordController.dispose();
    return super.close();
  }

  // Fake login method
  Future<void> login() async {
    
    emit(AuthFailure(''));
    emit(AuthLoading());
   if(emailController.text.isNotEmpty && passwordController.text.isNotEmpty){

     try {

      final supabase = Supabase.instance.client;

      final res =await supabase.auth.signInWithPassword(
          password: passwordController.text,
          email: emailController.text,
      );

      if (res.session != null) {

        emit(AuthSuccess());

        print('Login Successful!');
      } else {
        emit(AuthFailure('Invalid credentials'));
        print('Invalid credentials');

      }
    } catch (e) {
      emit(AuthFailure('Invalid credentials'));
        print('Invalid credentials');
    }
   }else{
     emit(AuthFailure('Fill All Fields'));
        print('Fill All Fields');
   }
  }

  // Fake signup method
  Future<void> signup() async {
    emit(AuthLoading());
    try {
      await Future.delayed(Duration(seconds: 2)); // Simulating network delay
      emit(AuthSuccess());
    } catch (e) {
      emit(AuthFailure('Something went wrong!'));
    }
  }
}



