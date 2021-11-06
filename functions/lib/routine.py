class Routine(object):
    def __init__(self, routineId, routineOwnerId, routineTitle, lastEditedDate,
                 routineCreatedDate, imageUrl, totalWeights, duration, trainingLevel,
                 isPublic, location, description, averageTotalCalories, thumbnailImageUrl,
                 mainMuscleGroupEnum, equipmentRequiredEnum, unitOfMassEnum):
        self.routineId = routineId
        self.routineOwnerId = routineOwnerId
        self.routineTitle = routineTitle
        self.lastEditedDate = lastEditedDate
        self.routineCreatedDate = routineCreatedDate
        self.imageUrl = imageUrl
        self.totalWeights = totalWeights
        self.duration = duration
        self.trainingLevel = trainingLevel
        self.isPublic = isPublic
        self.location = location
        self.description = description
        self.averageTotalCalories = averageTotalCalories
        self.thumbnailImageUrl = thumbnailImageUrl
        self.mainMuscleGroupEnum = mainMuscleGroupEnum
        self.equipmentRequiredEnum = equipmentRequiredEnum
        self.unitOfMassEnum = unitOfMassEnum
