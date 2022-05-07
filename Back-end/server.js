const express = require('express')
const morgan = require('morgan')
const cors = require('cors')
const connectDB = require('./config/db')
const passport = require('passport')
const bodyParser = require('body-parser')
const routes = require('./routes/index') 
const MCS_Bus = require('./models/MCS_Bus')
let Ticket = require('./models/tickets')
let Activated_Ticket = require('./models/Ticket_activated')
let R_Ticket = require('./models/Reserverd_ticket')
let Bus_Location = require('./models/BusLocation')
let Bus_Station = require('./models/Bus_Station')
let Ticket_history = require('./models/Ticket_history')
let User_Bus_Id = require('./models/User_Bus_IDs')
let Actions = require('./methods/actions')
let Capacity = require('./models/Capacity')
const { stringify } = require('nodemon/lib/utils')





const app = express()
const server = require("http").createServer(app)
const io = require("socket.io")(server, {cors: {origin: "*",  methods: ['GET', 'POST']},perMessageDeflate :false})

connectDB()


if (process.env.NODE_ENV === 'development') {
    app.use(morgan('dev'))
}

app.use(cors())
app.use(bodyParser.urlencoded({ extended: false }))
app.use(bodyParser.json())
app.use(routes)
app.use(passport.initialize())
require('./config/passport')(passport)


const PORT = process.env.PORT || 3000

server.listen(PORT, console.log(`Server running in ${process.env.NODE_ENV} mode on port ${PORT}`))

io.on("connection", (socket) => {
     //Tell the front-end to stream the bus location
     //socket.emit("bus-location", {bus_id: req.body.bus_id})
     socket.on ("bus-connection", (received) => {       
        //if the received msg has a bus_id save its location
        if(received.bus_id != undefined){
            const filter = { bus_id: received.bus_id }
            const update = { location: received.location}
            const options = { upsert: true } // Creates a new document if no documents match the (filter)
            Bus_Location.findOneAndUpdate(filter, update, 
                options, function (err){
                    if(err){
                        socket.emit("location-error", "Failed to get the current location of the bus")
                    }else{
                       socket.emit("location-received", "DONE!!!")
                    }
                }
            )
        }
   })

    //WORK ON THIS
    socket.on("user-stream-validate", (received) => {           //res.status(404).json({status: false, msg: 'Not valid'})
            check = received.ticket_id
            //first: check if the data are found in the activated ticekt
            Activated_Ticket.findById(check,function (err,result) {
                if (err){
                    console.log(err);
                }
                else{
                    if (result == null){
                        //if ticket not found in the activated ticket, check the reserved ticket 
                        R_Ticket.findById(check,function (err,result1) {
                            if (err){
                                console.log(err);
                            }
                            else{
                                if (result1 == null){  
                                    socket.emit("user-stream-feedback",{status: false, msg: 'Not valid'})                          
                                }else {
                                    socket.emit("user-stream-feedback",{status: true, msg: 'valid'})
                                    //found in reserved ticket? add the ticket to the activated ticket and remove it from reserved ticket 
                                    var one_hour = Activated_Ticket ({
                                        _id: result1.id,
                                        user_id:result1.user_id,
                                        type:result1.type
                                    })

                                    var ticket_for_history = Ticket_history({
                                        ticket_id: result1.id,
                                        user_id:result1.user_id,
                                        type:result1.type
                                    })

                                    var user_and_bus = User_Bus_Id({
                                        bus_id: received.bus_id,
                                        user_id:result1.user_id,
                                        type:result1.type
                                    })

                                    one_hour.save()
                                    ticket_for_history.save()
                                    user_and_bus.save()

                                    Bus_Station.find({
                                        location: {
                                            $near: {
                                                $geometry: {
                                                    type: "Point",
                                                    coordinates: [received.longitude,received.latitude]
                                                },
                                            $maxDistance: 100,
                                            }
                                        }
                                    }).find((err, results2) => {
                                        if (err) { console.log(err) }
                                        if (results2[0] != null) {
                                            var ticket_data = Ticket({
                                                // Extract data from the body
                                                bus_id: received.bus_id,
                                                user_id:result1.user_id,
                                                longitude: received.longitude,
                                                latitude: received.latitude,
                                                status: "IN",
                                                bus_station:results2[0].name
                                            });
                                        }else {
                                            var ticket_data = Ticket({
                                                // Extract data from the body
                                                bus_id: received.bus_id,
                                                user_id:result1.user_id,
                                                longitude: received.longitude,
                                                latitude: received.latitude,
                                                status: "IN",
                                                //bus_station:results2[0].name
                                            });
                                        }
                    
                                        ticket_data.save()
                                    })

                                    const filter = { bus_id: received.bus_id }
                                    const update = { $inc: {capacity:  result1.type} }
                                    const options = { upsert: true } // Creates a new document if no documents match the (filter)
                                    Capacity.findOneAndUpdate(filter, update, 
                                        options, function (err){
                                            if(err){
                                            console.log(err)
                                            }
                                        })
                                    result1.remove() //remove



                                }
                            }
                            
                        })

                    }else {
                        //console.log("Result : ",result ); 
                        socket.emit("user-stream-feedback", {status: true, msg: 'valid'}) 
                        Bus_Station.find({
                            location: {
                                $near: {
                                    $geometry: {
                                        type: "Point",
                                        coordinates: [received.longitude,received.latitude]
                                    },
                                $maxDistance: 100,
                                }
                            }
                        }).find((err, results2) => {
                            if (err) { console.log(err) }
                            if (results2[0] != null) {
                                var ticket_data = Ticket({
                                    // Extract data from the body
                                    bus_id: received.bus_id,
                                    user_id:result.user_id,
                                    longitude: received.longitude,
                                    latitude: received.latitude,
                                    status: "IN",
                                    bus_station:results2[0].name
                                });
                            }else {
                                var ticket_data = Ticket({
                                    // Extract data from the body
                                    bus_id: received.bus_id,
                                    user_id:result.user_id,
                                    longitude: received.longitude,
                                    latitude: received.latitude,
                                    status: "IN",
                                    //bus_station:results2[0].name
                                });
                            }

                            var user_and_bus = User_Bus_Id({
                                bus_id: received.bus_id,
                                user_id:result.user_id,
                                type:result.type

                            })

                            user_and_bus.save()
                            ticket_data.save()
                        })

                        const filter = { bus_id: received.bus_id }
                        const update = { $inc: {capacity:  result.type} }
                        const options = { upsert: true } // Creates a new document if no documents match the (filter)
                        Capacity.findOneAndUpdate(filter, update, 
                            options, function (err){
                                if(err){
                                   console.log("capacity-error")
                                }
                            })
                                    


                        //var post = Capacity.findOne({bus_id: received.bus_id}); 
                        //Capacity.findOneAndUpdate(post, {capacity: 1},{ upsert: true } )
                        //res.status(200).json({status: true, msg: 'valid!'})
                    }
                }
                
                
            })
        
    })

    // socket.emit("user-stream-feedback", "")
    socket.on("user-stream-location", (received) =>{
        User_Bus_Id.find({ user_id: received.user_id}, function (err, docs1) {
            console.log(docs1[0])
            let BUS = docs1[0].bus_id ; 
            let accuracy = received.accuracy;
            let type = docs1[0].type; 

            if (err){
                console.log(err);
            }
            else{
                Bus_Location.find({bus_id: BUS}, function (err, docs2) {
                    if (err){
                        console.log(err);
                    }
                    else{
                        console.log ("bus field", docs2[0])
                        let lat1 = received.latitude
                        let lng1 = received.longitude
                        let lat2 = docs2[0].location.coordinates[1]
                        let lng2 = docs2[0].location.coordinates[0]
                        let distance = Actions.calcCrow(lat1,lng1,lat2,lng2)
                        console.log(distance)

                        if (distance > (30 + accuracy)){
                            docs1[0].deleteOne();

                            Bus_Station.find({
                                location: {
                                    $near: {
                                        $geometry: {
                                            type: "Point",
                                            coordinates: [received.longitude,received.latitude]
                                        },
                                       $maxDistance: 100,
                                    }
                                }
                            }).find((err, results2) => {
                                //console.log(results2)
                                //if (err) { console.log(err) }
                                if (results2[0] != null) {
                                    var ticket_data = Ticket({
                                        // Extract data from the body
                                        bus_id: BUS,
                                        user_id:received.user_id,
                                        longitude: received.longitude,
                                        latitude: received.latitude,
                                        status: "OUT",
                                        bus_station:results2[0].name
                                    });

                                }else {
                                    var ticket_data = Ticket({
                                        // Extract data from the body
                                        bus_id: BUS,
                                        user_id:received.user_id,
                                        longitude: received.longitude,
                                        latitude: received.latitude,
                                        status: "OUT",
                                        //bus_station:results2[0].name
                                    });

                                }
                                ticket_data.save()
                                socket.emit("user-stream-off", "true")
                                socket.disconnect()
                                const filter = { bus_id: BUS }
                                const update = { $inc: {capacity:  -1} }
                                const options = { upsert: true } // Creates a new document if no documents match the (filter)
                                Capacity.findOneAndUpdate(filter, update, 
                                    options, function (err){
                                        if(err){
                                        console.log(err)
                                        }
                                    }) 
        
                                
                            }).catch((err) => {
                                //console.log(err)
                            });
                    

                    }
                }
                });
                



            }
        });
    })
})