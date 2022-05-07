// This module lets you authenticate endpoints using a JSON web token. 
// It is intended to be used to secure RESTful endpoints without sessions.

let JwtStrategy = require('passport-jwt').Strategy
let ExtractJwt = require('passport-jwt').ExtractJwt

let User = require('../models/user')
let config = require('./dbconfig')

module.exports = function (passport) {
    let opts = {}
    // secretOrKey is a string or buffer containing the secret (symmetric) or 
    // PEM-encoded public key (asymmetric) for verifying the token's signature.
    opts.secretOrKey = config.secret
    // jwtFromRequest a function that accepts a request as the only 
    // parameter and returns either the JWT as a string or null
    opts.jwtFromRequest = ExtractJwt.fromAuthHeaderWithScheme('jwt')

    passport.use(new JwtStrategy(opts, function (jwt_payload, done) {
        User.find({
            id: jwt_payload.id
        }, function (err, user) {
                if (err) {
                    return done(err, false)
                }
                if (user) {
                    return done(null, user)
                }

                else {
                    return done(null, false)
                }
        }
        )
    }))
}