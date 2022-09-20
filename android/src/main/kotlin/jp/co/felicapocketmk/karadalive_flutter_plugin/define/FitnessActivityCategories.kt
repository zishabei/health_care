package jp.co.felicapocketmk.karadalive_flutter_plugin.define

import com.google.android.gms.fitness.FitnessActivities

/**
 * FitnessActivitiesを大雑把にカテゴリ分けしたもの
 */
object FitnessActivityCategories {

    /**
     * running
     */
    val ON_RUNNING = arrayListOf(
            FitnessActivities.RUNNING,
            FitnessActivities.RUNNING_JOGGING,
            FitnessActivities.RUNNING_SAND,
            FitnessActivities.RUNNING_TREADMILL
    )

    /**
     * walking
     */
    val ON_WALKING = arrayListOf(
            FitnessActivities.WALKING,
            FitnessActivities.WALKING_FITNESS,
            FitnessActivities.WALKING_NORDIC,
            FitnessActivities.WALKING_STROLLER,
            FitnessActivities.WALKING_TREADMILL
    )

    /**
     * cycling
     */
    val ON_BICYCLE = arrayListOf(
            FitnessActivities.BIKING,
            FitnessActivities.BIKING_HAND,
            FitnessActivities.BIKING_MOUNTAIN,
            FitnessActivities.BIKING_ROAD,
            FitnessActivities.BIKING_SPINNING,
            FitnessActivities.BIKING_STATIONARY,
            FitnessActivities.BIKING_UTILITY
    )
}