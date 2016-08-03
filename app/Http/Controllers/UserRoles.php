<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Http\Requests;
use App\User;
use Illuminate\Support\Facades\DB;


class UserRoles
{

    public static function roles($email)
    {
        
        $user = User::where('email','=',$email)->get()->first();
  
        return array('name' => $user->name, 'email' => $user->email, 'roles' => UserRoles::flattenRoles($user->roles()->select('roles')->get()));
    }

    public static function flattenRoles($arr)
    {
        $roles = array();
        foreach ($arr as $ar) {
            array_push($roles, $ar->roles);
        }
        return ($roles);
    }


}

