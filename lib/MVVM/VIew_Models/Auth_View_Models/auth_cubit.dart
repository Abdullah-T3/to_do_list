import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:to_do_list_zagsystem/MVVM/Models/Auth_Models/AuthModel.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final TextEditingController RewritePassController = TextEditingController();
  final TextEditingController DisplayNameController = TextEditingController();
  
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


        emit(AuthSuccess());


    } catch (e) {
       if(e is AuthException){
         print(e.message);

          emit(AuthFailure(e.message.toString()));

       }else{
         emit(AuthFailure('Something went wrong!'));
       }
    }
   }else{
     emit(AuthFailure('Fill All Fields'));
   }
  }

  // Fake signup method
  Future<void> signup() async {

    emit(AuthFailure(''));
    emit(AuthLoading());
    if(emailController.text.isNotEmpty && passwordController.text.isNotEmpty && DisplayNameController.text.isNotEmpty&& RewritePassController.text.isNotEmpty){
  if(passwordController.text == RewritePassController.text){
  try {
    final supabase = Supabase.instance.client;

    final res = await supabase.auth.signUp(
        password: passwordController.text,
        email: emailController.text,
        data: {
          'display_name': DisplayNameController.text
        }
    );


    emit(AuthSuccess());
  } catch (e) {
    if (e is AuthException) {
      print(e.message);

      emit(AuthFailure(e.message.toString()));
    } else {
      print(e);
      emit(AuthFailure('Something went wrong!'));
    }
  }
}else{
    emit(AuthFailure('Passwords are not the same'));

  }
    }else{
      emit(AuthFailure('Fill All Fields'));
    }
  }
}



