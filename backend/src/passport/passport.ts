import { PassportStatic } from "passport";
import { Strategy } from "passport-local";
import { User } from "../model/User";

export const configurePassport = (passport: PassportStatic): PassportStatic => {

    passport.serializeUser((user: Express.User, done) => {
        const newUser = {
            ...user, 
        }
        console.log('serialize user: ' + user);
        //User.findOne({user.username})
        done(null, user);
    });

    passport.deserializeUser((user: Express.User, done) => {
        console.log('deserialize user: ' + user);
        done(null, user);
    });
    
    passport.use('local', new Strategy(async (username, password, done) => {
        const query = User.findOne({email: username});
        query.then(user => {
            if (user) {
                user.comparePassword(password, (error, isMatch) => {
                    if (error) {
                        done('Incorrect username or password.');
                    } else {
                        done(null, user._id);
                    }
                });
            } else {
                done(null, undefined);
            }
        }).catch(error => {
            done(error);
        });
    }));

    return passport;
}