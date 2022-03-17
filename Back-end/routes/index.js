const express = require('express')
const actions = require('../methods/actions')
const router = express.Router()

router.get('/', (req, res) => {
    res.send('Hello World')
})

router.get('/dashboard', (req, res) => {
    res.send('Dashboard')
})

//@desc Adding new user
//@route POST /adduser

////Change it to /signup
router.post('/signup', actions.addNew)

//@desc Authenticate a user
//@route POST /authenticate

//Change it to /signin
router.post('/signin', actions.authenticate)

//@desc Get info on a user
//@route GET /getinfo
router.get('/getinfo', actions.getinfo)

// route for adding the ticket info
router.get('/checkticket', actions.check_ticket)

// route for validating the ticket
//router.get('/ticketvalidation', actions.ticket_validation)

//route for reserving the ticket ... 
router.get('/reservetickets', actions.R_ticket)


module.exports = router