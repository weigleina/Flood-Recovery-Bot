function sysCall_init()
         
    -- This is executed exactly once, the first time this script is executed
    bubbleRob=sim.getObjectHandle(sim.handle_self) -- this is bubbleRob's handle
    leftMotor=sim.getObjectHandle("bubbleRob_leftMotor") -- Handle of the left motor
    rightMotor=sim.getObjectHandle("bubbleRob_rightMotor") -- Handle of the right motor
    noseSensor=sim.getObjectHandle("bubbleRob_sensor_ultrasonic") -- Handle of the ultrasonic proximity sensor. Used to prevent collisions.
    noseSensorHeat=sim.getObjectHandle("bubbleRob_sensor_infrared") -- Handle of the infrared proximity sensor. Used to detect heat signatures.
    noseSensorWater=sim.getObjectHandle("bubbleRob_sensor_laser") -- Handle of the laser proximity sensor. Used to prevent robot from entering water.
    minMaxSpeed={50*math.pi/180,300*math.pi/180} -- Min and max speeds for each motor
    backUntilTime=-1 -- Tells whether bubbleRob is in forward or backward mode
    robotCollection=sim.createCollection(0)
    sim.addItemToCollection(robotCollection,sim.handle_tree,bubbleRob,0)
    distanceSegment=sim.addDrawingObject(sim.drawing_lines,4,0,-1,1,{0,1,0})
    robotTrace=sim.addDrawingObject(sim.drawing_linestrip+sim.drawing_cyclic,2,0,-1,200,{1,1,0},nil,nil,{1,1,0})
    graph=sim.getObjectHandle('bubbleRob_graph')
    distStream=sim.addGraphStream(graph,'bubbleRob clearance','m',0,{1,0,0})
    -- Create the custom UI:
    xml = '<ui title="'..sim.getObjectName(bubbleRob)..' speed" closeable="false" resizeable="false" activate="false">'..[[
                <hslider minimum="0" maximum="100" on-change="speedChange_callback" id="1"/>
            <label text="" style="* {margin-left: 300px;}"/>
        </ui>
        ]]
    ui=simUI.create(xml)
    speed=(minMaxSpeed[1]+minMaxSpeed[2])*0.5
    simUI.setSliderValue(ui,1,100*(speed-minMaxSpeed[1])/(minMaxSpeed[2]-minMaxSpeed[1]))
    
end

function sysCall_sensing()
    local result,distData=sim.checkDistance(robotCollection,sim.handle_all)
    if result>0 then
        sim.addDrawingObjectItem(distanceSegment,nil)
        sim.addDrawingObjectItem(distanceSegment,distData)
        sim.setGraphStreamValue(graph,distStream,distData[7])
    end
    local p=sim.getObjectPosition(bubbleRob,-1)
    sim.addDrawingObjectItem(robotTrace,p)
end 

function speedChange_callback(ui,id,newVal)
    speed=minMaxSpeed[1]+(minMaxSpeed[2]-minMaxSpeed[1])*newVal/100
end

function sysCall_actuation() 
    result=sim.readProximitySensor(noseSensor) -- Read the ultrasonic sensor
    -- If we detected debris, we print a message and set the backward mode:
    if (result>0) then print("barrier") end
    if (result>0) then backUntilTime=sim.getSimulationTime()+4 end 
    
    result=sim.readProximitySensor(noseSensorWater) -- Read the laser sensor
    -- If we detected water, we print a message and set the backward mode:
    if (result>0) then print("water detected") end 
    if (result>0) then backUntilTime=sim.getSimulationTime()+2 end 
    
    result=sim.readProximitySensor(noseSensorHeat) -- Read the infrared sensor
    -- If we detected heat, we print a message and set the backward mode:
    if (result>0) then print("heat detected") end 

    if (backUntilTime<sim.getSimulationTime()) then
        -- When in forward mode, we simply move forward at the desired speed
        sim.setJointTargetVelocity(leftMotor,speed)
        sim.setJointTargetVelocity(rightMotor,speed)
    else
        -- When in backward mode, we simply backup in a curve at reduced speed
        sim.setJointTargetVelocity(leftMotor,-speed/2)
        sim.setJointTargetVelocity(rightMotor,-speed/8)
    end
end

function sysCall_cleanup() 
    simUI.destroy(ui)
end 