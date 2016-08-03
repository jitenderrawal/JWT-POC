<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

use App\Http\Requests;
use App\Http\Controllers\Controller;
use JWTAuth;
use Tymon\JWTAuth\Exceptions\JWTException;
use App\User;

class AuthenticateController extends Controller
{

    public function __construct()
    {
        // Apply the jwt.auth middleware to all methods in this controller
        // except for the authenticate method. We don't want to prevent
        // the user from retrieving their token if they don't already have it
        $this->middleware('jwt.auth', ['except' => ['authenticate']]);
    }

    /**
     * This is protected controller which will be accessible only with a valid jwt token. If the token is
     * valid it will parse the token and return the custom payload with all the claims and roles
     *
     * @return Response
     */
    public function index()
    {
        $payload = JWTAuth::parseToken()->getPayload();

        return "Authentication Successfully.  Payload was " . $payload;
    }

    /**
     * Authenticate inclReturn a JWT
     *
     * @return Response
     */
    public function authenticate(Request $request)
    {
        $credentials = $request->only('email', 'password');

        try {
            // verify the credentials against the database and create jwt token for the user
            if (! $token = JWTAuth::attempt($credentials,UserRoles::roles($credentials['email']))) {
                return response()->json(['error' => 'invalid_credentials'], 401);
            }
        } catch (JWTException $e) {
            // something went wrong
            return response()->json(['error' => 'could_not_create_token'], 500);
        }

        // if no errors are encountered we can return a JWT
        return response()->json(compact('token'));
    }
}
