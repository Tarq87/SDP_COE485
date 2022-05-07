const express = require('express')
const { Bus_Capacity } = require('../methods/actions')
const actions = require('../methods/actions')
const router = express.Router()


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
router.post('/checkticket',actions.check_ticket)

//route for reserving the ticket ... 
router.post('/reservetickets', actions.R_ticket)

// request the location of the stations 
router.get('/requeststations',actions.Bus_Stops_List)

//request the capacity of the buses 
router.get('/capacity',actions.Bus_Capacity)

//return the valid tickets for the user 
router.post('/updatetickets', actions.Update_Tickets)

// add location
router.post('/busLocation', actions.addlocations)

router.get('/getusers', actions.get_users)

router.get('/gettickets', actions.get_tickets)

router.get('/getdrivers', actions.get_driver)

router.get('/ticketsales', actions.tickets_sales)



router.get('/requestbuses', actions.request_buses_location)

//get the points for a specific user
router.post('/points', actions.points)





module.exports = router