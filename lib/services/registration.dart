import 'dart:convert';
import 'package:http/http.dart' as http;

import '../variables/ip_address.dart';
import '../model/api_response.dart';
import '../model/user.dart';

Future<ApiResponse>register(
  String lastname,
  String firstname,
  String middlename,
  String account_type, 
  String department, 
  String email,
  String password,  
  String password_confirmation,

   )

async{
    ApiResponse apiResponse = ApiResponse();
        try{
          final response = await http.post(
            Uri.parse('$ipaddress/register'),
            headers: {'Accept':'application/json'},
            body: {'lastname':lastname, 
                   'firstname':firstname, 
                   'middlename':middlename,
                   'department':department,
                   'user_type':account_type,
                   'email':email,
                   'password':password, 
                   'password_confirmation':password_confirmation
                   }
          );
          switch(response.statusCode){
            case 200:
              apiResponse.data = User.fromJson(jsonDecode(response.body));
              break;
            case 422:
              final errors = jsonDecode(response.body)['message'];
              apiResponse.error = errors;
              break;
            case 403:
              apiResponse.error = jsonDecode(response.body)['message'];
              break;
            default:
              apiResponse.error = 'Something went wrong.';
              break;
          }
        }catch(e){
          apiResponse.error = 'Something went wrong.';
        }
    return apiResponse;
}