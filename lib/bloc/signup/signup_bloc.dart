import 'package:flutter_bloc/flutter_bloc.dart';
import 'signup_event.dart';
import 'signup_state.dart';
import '../../graphql/shopify_client.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupBloc() : super(SignupInitial()) {
    on<SignupSubmitted>(_onSignupSubmitted);
  }

  Future<void> _onSignupSubmitted(
    SignupSubmitted event,
    Emitter<SignupState> emit,
  ) async {
    emit(SignupLoading());
    final client = getShopifyClient();

    final mutation =
        '''
      mutation {
        customerCreate(input: {
          email: "${event.email}",
          password: "${event.password}"
        }) {
          customer {
            id
            email
          }
          customerUserErrors {
            field
            message
          }
        }
      }
    ''';

    try {
      final result = await client.mutate(
        MutationOptions(document: gql(mutation)),
      );

      if (result.hasException) {
        emit(SignupFailure(result.exception.toString()));
        return;
      }

      final errors = result.data?['customerCreate']['customerUserErrors'];
      if (errors != null && errors.isNotEmpty) {
        emit(SignupFailure(errors[0]['message']));
      } else {
        emit(SignupSuccess());
      }
    } catch (e) {
      emit(SignupFailure(e.toString()));
    }
  }
}
