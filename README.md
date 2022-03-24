# aws_login

A Flutter project with a login/signup UI, and a simple AWS backend.
Code mostly utilised from tutorial series by Kilo Loco (free to reuse).

Project is significantly more complex than anything I've written wholly independently, but I wish to display it as it was a steep learning curve with both bloc/cubit state management and the AWS auth. Both of those features weren't working by the time I went to recreate the project, so it took quite a bit of independent searching to update the code in line with newer version of those packages. In general also, the tutorial was a mess in terms of null checks and handling errors, so I cleaned that up (as best I know how), as well as adding improved checks for valid passwords/emails, and a cleaner UI. 

The tutorial series continues on with more complex features, such as a database with user profile pictures displayed after login, however I decided not to include that further build on here as I don't understand it as well. 

The dart code (the body of the project) is contained in the 'Lib' folder. 

