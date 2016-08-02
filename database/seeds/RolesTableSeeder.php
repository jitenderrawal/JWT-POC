<?php

use Illuminate\Database\Seeder;
use App\Roles;

class RolesTableSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {

        DB::table('roles')->delete();

        //Roles::all()->get('id');
        //echo Roles::all()->get('id');
        //Roles::destroy(Roles::all()->get('id'));

        Roles::create(['user_id'=>6,'roles'=>'admin']);
        Roles::create(['user_id'=>6,'roles'=>'attorney']);
        Roles::create(['user_id'=>6,'roles'=>'orgeditor']);
    }
}
