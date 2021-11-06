from google.cloud import firestore

client = firestore.Client()


def on_user_update(data, context):
    """Triggered by a change to a Firestore document.
    Args:
         event (dict): Event payload.
         context (google.cloud.functions.Context): Metadata for the event.
    """

    print('function called')

    trigger_resource = context.resource
    path_parts = trigger_resource.split('/documents/')[1].split('/')
    uid = '/'.join(path_parts[1:])

    new_display_name = data['value']['fields']['displayName']['stringValue']

    print(f'new_display_name: {new_display_name}')

    print(f'uid is {uid}')

    # Routines
    routines_collection = client.collection(u'routines')
    routines = routines_collection.where(u'routineOwnerId', u'==', uid).get()

    for routine in routines:
        routine_dict = routine.to_dict()
        routine_ownername = str(routine_dict['routineOwnerUserName'])

        print(f'name in routine: {routine_ownername}')

        if routine_ownername.strip() != new_display_name.strip():

            routineId = routine.id
            routine_doc = routines_collection.document(routineId)

            routine_doc.update({
                u'routineOwnerUserName': new_display_name
            })
        else:
            print('routine username is same, no need to change')

    # Workouts
    workouts_collection = client.collection(u'workouts')
    workouts = workouts_collection.where(u'workoutOwnerId', u'==', uid).get()

    for workout in workouts:
        workout_dict = workout.to_dict()
        workout_ownername = str(workout_dict['workoutOwnerUserName'])

        print(f'name in workout: {workout_ownername}')

        if workout_ownername.strip() != new_display_name.strip():
            workoutId = workout.id
            workout_doc = workouts_collection.document(workoutId)

            workout_doc.update({
                u'workoutOwnerUserName': new_display_name
            })
        else:
            print('workout username is same, no need to change')

    print('function finished')
