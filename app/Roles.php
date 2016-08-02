<?php

namespace App;


use Illuminate\Database\Eloquent\Model;

class Roles extends Model 
{
    

    /**
     * The database table used by the model.
     *
     * @var string
     */
    protected $table = 'roles';

    /**
     * The attributes that are mass assignable.
     *
     * @var arrayk
     */
    protected $fillable = ['user_id', 'roles'];

    /**
     * The attributes excluded from the model's JSON form.
     *
     * @var array
     */
    //protected $hidden = ['password', 'remember_token'];

    public function user()

    {
        return $this->hasOne('App\User');
    }
}
