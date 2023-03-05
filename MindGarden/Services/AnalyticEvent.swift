//
//  AnalyticEvent.swift
//  MindGarden
//
//  Created by Dante Kim on 10/7/21.
//

import Foundation

enum AnalyticEvent {
    case sceneDidBecomeActive
    case launchedApp

    //MARK: - Onboarding
    case screen_load_onboarding //
    case onboarding_notification_on
    case onboarding_notification_off
    case onboarding_tapped_continue //
    case onboarding_tapped_sign_in //
    case onboarding_tapped_allowed_att
    case onboarding_tapped_denied_att
    case onboarding_loading_illusion // 
    case show_onboarding_rating //
    case update_triggered_auth //
    case show_onboarding_auth //
    case screen_load_pricing_onboarding

    //experience
    case screen_load_experience //
    case experience_tapped_none //
    case experience_tapped_some //
    case experience_tapped_alot //
    case experience_tapped_continue //
    case experience_tapped_okay_push //
    case experience_tapped_not_now // 

    //MARK: - Reason
    case screen_load_reason
    case reason_tapped_sleep
    case reason_tapped_focus
    case reason_tapped_stress
    case reason_tapped_trying
    case reason_tapped_improveMood
    case reason_tapped_bePresent
    case reason_tapped_continue

    //MARK: - Review
    case screen_load_review
    case review_tapped_tutorial
    case review_tapped_explore
    case review_notification_on
    case review_notification_off

    //name
    case screen_load_name //
    case name_tapped_continue //
    //notification
    case screen_load_notification //
    case notification_tapped_done //
    case notification_tapped_turn_on //
    case notification_success //
    case notification_tapped_skip //
    case notification_go_to_settings //
    case notification_tapped_intro_reminder //
    case notification_tapped_oneDay_reminder //
    case notification_tapped_threeDay_reminder //
    case notification_tapped_streakNotStarted //
    case notification_tapped_onboarding //
    case notification_tapped_widget //
    case notification_tapped_store
    case notification_tapped_learn //
    // home + garden
    case onboarding_finished_mood //
    case onboarding_finished_gratitude //
    case onboarding_finished_meditation //
    case onboarding_finished_calendar //
    case onboarding_finished_stats //
    case onboarding_finished_single //
    case onboarding_finished_single_okay //
    case onboarding_finished_single_course //
    case onboarding_claimed_strawberry //
    case onboarding_came_from_referral // 

    //MARK: - Authentication
    case screen_load_onboarding_signup //
    case screen_load_onboarding_signin //
    case screen_load_signup //
    case screen_load_signin //
    case authentication_signin_successful //
    case authentication_signup_successful //
    case authentication_tapped_google //
    case authentication_tapped_apple //
    case authentication_tapped_forgot_password //
    case authentication_signuped_newsletter //
    case screen_load_newAuthenticaion //
    case newAuthentication_tapped_x
    case authentication_tapped_signup_email //
    case tapped_already_have_account //

    //MARK: - Garden
    case screen_load_garden //
    case garden_next_month //
    case garden_previous_month //
    case garden_tapped_single_day //
    // left & right arrow in single day modal if present
    case garden_tapped_single_next_session //
    case garden_tapped_single_previous_session //
    case screen_load_single
    case screen_load_single_onboarding
    case garden_tapped_settings
    case garden_tapped_plant_select
    case garden_tapped_monthly_stats

    //MARK: - HOME
    case screen_load_home //
    case home_tapped_plant_select //
    case home_selected_plant //
    case home_tapped_categories //
    case home_tapped_floatingMenu //
    case home_tapped_profile //
    case home_tapped_journal //
    case home_tapped_mood //
    case home_tapped_recents //
    case home_tapped_favorites //
    case home_tapped_recent_meditation //
    case home_tapped_favorite_meditation //
    case home_tapped_featured_breath //
    case home_tapped_featured_meditation //
    case home_tapped_introDay //
    case home_tapped_see_you_tomorrow
    case home_selected_mood //
    case home_tapped_new_meditation //
    case home_tapped_weekly_meditation //
    case home_tapped_locked_meditation //
    case home_tapped_streak
    case home_tapped_real_tree
    case challenge_tapped_x //
    case challenge_tapped_accept //
    
    //MARK: - Mood Check
    case screen_load_mood_elaborate
    case elaborate_tapped_edit
    case elaborate_add_new_mood
    case elaborate_delete_mood
    
    //MARK: - Journal
    case screen_load_journal
    case journal_tapped_done
    case journal_tapped_prompts
    case journal_tapped_shuffle
    case journal_tapped_x
    
    //MARK: - Recommendations

    case screen_load_recs //
    case onboarding_load_recs //
    case onboarding_tapped_30_second //
    case recommendations_tapped_breath //
    case recommendations_tapped_med //
    case recommendations_tapped_x //
    case recs_tapped_see_more
    
    //MARK: - Breathwork
    
    //MARK: - Next Steps
    case screen_load_nextsteps
    case nextsteps_created_reminder
    case nextsteps_tapped_save_progress
    case nextsteps_tapped_done
    
    //MARK: - Streak
    case screen_load_streak
    case rating_tapped_yes
    case rating_tapped_no
    
    // bonus modal
    case home_tapped_bonus //
    case home_tapped_pro
    case home_claim_daily //
    case home_claim_seven //
    case home_claim_thirty //
    case home_tapped_IAP //
    case home_tapped_journey_med
    
    // IAP
    case IAP_tapped_freeze
    case IAP_tapped_potion
    case IAP_tapped_chest

    //MARK: - Store
    case screen_load_shop_page
    case store_tapped_plant_tile //
    case store_tapped_purchase_modal_buy //
    case store_tapped_confirm_modal_confirm //
    case store_tapped_confirm_modal_cancel //
    case store_tapped_success_modal_okay //
    case store_tapped_rate_app //
    case store_tapped_refer_friend //
    case store_tapped_discord //
    case store_tapped_go_pro
    case store_tapped_badge_tile
    case store_animation_continue //
    case store_tapped_buy_real_tree //
    case store_bought_real_tree //
    case notification_success_store //
    case notification_settings_store //
    case screen_load_plant_select
    case selected_plant
    case screen_load_badge
    case screen_load_store
    case screen_load_real_tree
    

    //MARK: - Middle
    case screen_load_middle //
    case middle_tapped_favorite //
    case middle_tapped_unfavorite
    case middle_tapped_back //
    case middle_tapped_recommended //
    case middle_tapped_row //
    case middle_tapped_row_favorite //
    case middle_tapped_row_unfavorite //
    case middle_tapped_locked_recommended //
    case middle_tapped_plant_select //

    //MARK: - Play
    case screen_load_play //
    case play_tapped_back //
    case play_tapped_favorite //
    case play_tapped_unfavorite
    case play_tapped_sound //
    case play_tapped_sound_rain //
    case play_tapped_sound_night //
    case play_tapped_sound_beach //
    case play_tapped_sound_nature //
    case play_tapped_sound_fire //
    case play_tapped_sound_noSound //
    case play_tapped_hz //
    case play_tapped_instrument //

    //MARK: - Finished
    case screen_load_finished //
    case finished_save_progress //
    case finished_not_now //
    case finished_tapped_share //
    case finished_tapped_favorite //
    case finished_tapped_unfavorite
    case finished_tapped_finished //
    case finished_tapped_gratitude //
    case finished_tapped_mood //
    case finished_set_reminder //
  
    
    //MARK: - Discover
    case screen_load_discover
    case screen_load_journey
    case discover_tapped_journey_med
    case discover_tapped_search
    
    
    //MARK: - Learn
    case screen_load_learn //
    case notification_success_learn //
    case notification_settings_learn //
    case learn_tapped_meditation_course //
    case learn_finished_meditation_course //
    case learn_tapped_life_course //
    case learn_finished_life_course //


    //MARK: - Profile
    case screen_load_profile //
    case profile_tapped_profile //
    case profile_tapped_background_on
    case profile_tapped_background_off
    case profile_tapped_settings //
    case profile_tapped_email //
    case profile_tapped_discord //
    case profile_tapped_invite //
    case profile_tapped_notifications //
    case profile_tapped_instagram //
    case profile_tapped_restore //
    case profile_tapped_feedback //
    case profile_tapped_roadmap //
    case profile_tapped_goPro //
    case profile_tapped_toggle_off_notifs //
    case profile_tapped_toggle_on_notifs //
    case profile_tapped_toggle_off_mindful //
    case profile_tapped_toggle_on_mindful //
    case profile_tapped_logout //
    case profile_tapped_refer //
    case profile_tapped_refer_friend //
    case profile_tapped_rate //
    case profile_tapped_create_account //
    case profile_tapped_add_widget //
    case profile_tapped_delete_account //
    case profile_tapped_garden //
    case profile_tapped_garden_date_on //
    case profile_tapped_garden_date_off // 
    //MARK: - Categories
    case screen_load_categories //
    case categories_tapped_unguided //
    case categories_tapped_all //
    case categories_tapped_courses //
    case categories_tapped_anxiety //
    case categories_tapped_focus //
    case categories_tapped_growth //
    case categories_tapped_meditation //
    case categories_tapped_sleep //
    case categories_tapped_confidence //
    case categories_tapped_request //
    case categories_tapped_locked_meditation //
    case categories_tapped_square //
    
    //MARK: - Breathwrk
    case breathwrk_middle_favorited
    case breathwrk_middle_duration_1
    case breathwrk_middle_duration_3
    case breathwrk_middle_duration_5
    case breathwrk_middle_duration_10
    case breathwrk_middle_tapped_back
    case breathwrk_middle_tapped_settings
    case screen_load_breathwrk_middle

    //MARK: - tabs + plus
    case tabs_tapped_meditate //
    case tabs_tapped_garden //
    case tabs_tapped_store //
    case tabs_tapped_profile //
    case tabs_tapped_plus //
    case tabs_tapped_search //
    //plus
    case plus_tapped_mood //
    case plus_tapped_mood_to_pricing
    //mood
    case mood_tapped_angry //
    case mood_tapped_sad //
    case mood_tapped_okay //
    case mood_tapped_happy //
    case mood_tapped_stress //
    case mood_tapped_good //
    case mood_tapped_veryGood //
    case mood_tapped_bad //
    case mood_tapped_veryBad
    case plus_selected_mood //
    case mood_tapped_x //
    case mood_tapped_done //
    
    //gratitude
    case plus_tapped_gratitude
    case plus_tapped_gratitude_to_pricing
    case gratitude_tapped_done // 
    case gratitude_tapped_cancel
    case gratitude_tapped_prompts

    case plus_tapped_meditate
    case plus_tapped_meditate_to_pricing
    case seventh_time_coming_back

    //pricing
    case screen_load_pricing
    case screen_load_superwall
    case screen_load_14pricing
    case yearly_started_from_superwall
    case monthly_started_from_superwall
    case screen_load_50pricing
    case modal_50_not_now
    case pricing_from_home
    case pricing_from_locked
    case pricing_from_profile
    case pricing_from_store
    case pricing_tapped_notif_ok
    case pricing_tapped_notif_not_now
    case pricing_notif_accepted
    case pricing_notif_denied
    case user_from_influencer
    
    //Stories
    case story_notification_swipe
    case story_notification_swipe_gratitude
    case story_swipe_trees_future
    case story_comic_opened
    case story_bijan_opened
    case story_journal_opened
    case story_quote_opened
    case story_tip_opened
    
    case no_thanks_50
    case widget_tapped_no_thanks
    case widget_tapped_finished
    case widget_tapped_breathwork
    case widget_tapped_meditate
    case widget_tapped_logMood
    case widget_tapped_journal
}

extension AnalyticEvent {
    static func getSound(sound: Sound) -> AnalyticEvent {
        switch sound {
        case .beach:
            return .play_tapped_sound_beach
        case .fire:
            return .play_tapped_sound_fire
        case .rain:
            return .play_tapped_sound_rain
        case .night:
            return .play_tapped_sound_night
        case .noSound:
            return .play_tapped_sound_noSound
        case .nature:
            return .play_tapped_sound_nature
        case .fourThirtyTwo:
            return .play_tapped_hz
        case .theta:
            return .play_tapped_hz
        case .alpha:
            return .play_tapped_hz
        case .beta:
            return .play_tapped_hz
        case .flute:
            return .play_tapped_instrument
        case .guitar:
            return .play_tapped_instrument
        case .music:
            return .play_tapped_instrument
        case .piano1:
            return .play_tapped_instrument
        case .piano2:
            return .play_tapped_instrument
        }
    }
    static func getTab(tabName: String) -> AnalyticEvent {
        switch tabName {
        case "Garden":
            return .tabs_tapped_garden
        case "Meditate":
            return .tabs_tapped_meditate
        case "Shop":
            return .tabs_tapped_store
        case "Profile":
            return .tabs_tapped_profile
        case "Search":
            return .tabs_tapped_search
        default:
            return .tabs_tapped_meditate
        }
    }
}

extension AnalyticEvent {
    var eventName:String {
        switch self {
        case .sceneDidBecomeActive: return "sceneDidBecomeActive"
        case .launchedApp: return "launchedApp"
        case .screen_load_pricing_onboarding: return "screen_load_pricing_onboarding"
        case .breathwrk_middle_favorited: return "breathwrk_middle_favorited"
        case .breathwrk_middle_duration_1: return "breathwrk_middle_duration_1"
        case .breathwrk_middle_duration_3: return "breathwrk_middle_duration_3"
        case .breathwrk_middle_duration_5: return "breathwrk_middle_duration_5"
        case .breathwrk_middle_duration_10: return "breathwrk_middle_duration_10"
        case .breathwrk_middle_tapped_back: return "breathwrk_middle_tapped_back"
        case .breathwrk_middle_tapped_settings: return "breathwrk_middle_tapped_settings"
        case .screen_load_breathwrk_middle: return "screen_load_breathwrk_middle"
            
            
        case .screen_load_onboarding: return "screen_load_onboarding"
        case .onboarding_tapped_continue: return "onboarding_tapped_continue"
        case .onboarding_tapped_sign_in: return "onboarding_tapped_sign_in"
        case .onboarding_tapped_allowed_att: return "onboarding_tapped_allowed_att"
        case .onboarding_tapped_denied_att: return "onboarding_tapped_denied_att"
        case .show_onboarding_rating: return "show_onboarding_rating"
        case .screen_load_experience: return "screen_load_experience"
        case .experience_tapped_none: return "experience_tapped_none"
        case .experience_tapped_some: return "experience_tapped_some"
        case .experience_tapped_alot: return "experience_tapped_alot"
        case .experience_tapped_continue: return "experience_tapped_continue"
        case .experience_tapped_okay_push: return "experience_tapped_okay_push"
        case .experience_tapped_not_now: return "experience_tapped_not_now"
        case .screen_load_reason: return "screen_load_reason"
        case .reason_tapped_sleep: return "reason_tapped_sleep"
        case .reason_tapped_focus: return "reason_tapped_focus"
        case .reason_tapped_stress: return "reason_tapped_stress"
        case .reason_tapped_trying: return "reason_tapped_trying"
        case .reason_tapped_improveMood: return "reason_tapped_improveMood"
        case .reason_tapped_bePresent: return "reason_tapped_bePresent"
        case .reason_tapped_continue: return "reason_tapped_continue"
        case .screen_load_name: return "screen_load_name"
        case .name_tapped_continue: return "name_tapped_continue"
        case .screen_load_notification: return "screen_load_notification"
        case .notification_tapped_done: return "notification_tapped_done"
        case .notification_tapped_turn_on: return "notifcation_tapped_turn_on"
        case .notification_success: return "notification_success"
        case .notification_tapped_skip: return "notification_tapped_skip"
        case .notification_go_to_settings: return "notification_go_to_settings"
        case .onboarding_finished_mood: return "onboarding_finished_mood"
        case .onboarding_notification_off: return "onboarding_notification_off"
        case .onboarding_notification_on: return "onboarding_notification_on"
        case .onboarding_finished_gratitude: return "onboarding_finished_meditation"
        case .onboarding_finished_meditation: return "onboarding_finished_meditation"
        case .onboarding_finished_calendar: return "onboarding_finished_calendar"
        case .onboarding_finished_stats: return "onboarding_finished_stats"
        case .onboarding_finished_single: return "onboarding_finshed_single"
        case .onboarding_finished_single_okay: return "onboarding_finshed_single_okay"
        case .onboarding_finished_single_course: return "onboarding_finished_single_course"
        case .onboarding_loading_illusion: return "onboarding_loading_illusion"
        case .screen_load_onboarding_signup: return "screen_load_onboarding_signup"
        case .onboarding_claimed_strawberry: return "onboarding_claimed_strawberry"
        case .screen_load_onboarding_signin:  return "screen_load_onboarding_signin:"
        case .onboarding_came_from_referral: return "onboarding_came_from_referral"
        case .screen_load_signup: return "screen_load_signup"
        case .screen_load_signin: return "screen_load_signin"
        case .screen_load_newAuthenticaion: return "screen_load_newAuthenticaion"
        case .newAuthentication_tapped_x: return "newAuthentication_tapped_x"
        case .authentication_tapped_signup_email: return "authentication_tapped_signup_email"
        case .authentication_signin_successful: return "authentication_signin_successful"
        case .authentication_signup_successful: return "authentication_signup_successful"
        case .authentication_tapped_google: return "authentication_tapped_google"
        case .authentication_tapped_apple:  return "authentication_tapped_apple"
        case .authentication_tapped_forgot_password: return "authentication_tapped_forgot_password"
        case .authentication_signuped_newsletter: return "authentication_signuped_newsletter"
        case .tapped_already_have_account: return "tapped_already_have_account"
        case .screen_load_garden: return "screen_load_garden"
        case .garden_next_month: return "garden_next_month"
        case .garden_previous_month: return "garden_previous_month"
        case .garden_tapped_single_day: return "garden_tapped_single_day"
        case .garden_tapped_single_next_session: return "garden_tapped_single_next_session"
        case .garden_tapped_single_previous_session: return "garden_tapped_single_previous_session"
        case .garden_tapped_settings: return "garden_tapped_settings"
        case .garden_tapped_plant_select: return "garden_tapped_plant_select"
        case .garden_tapped_monthly_stats: return "garden_tapped_monthly_stats"
        case .screen_load_home: return "screen_load_home"
        case .home_tapped_see_you_tomorrow: return "home_tapped_see_you_tomorrow"
        case .home_tapped_plant_select: return "home_tapped_plant_select"
        case .home_tapped_pro: return "home_tapped_pro"
        case .home_selected_plant: return "home_selected_plant"
        case .home_tapped_categories: return "home_tapped_categories"
        case .home_tapped_profile: return "home_tapped_profile"
        case .home_tapped_recents: return "home_tapped_recents"
        case .home_tapped_favorites: return "home_tapped_favorites"
        case .home_tapped_featured_breath: return "home_tapped_featured_breath"
        case .home_tapped_featured_meditation: return "home_tapped_featured_meditation"
        case .home_tapped_introDay: return "home_tapped_introDay"
        case .home_tapped_mood: return "home_tapped_mood"
        case .home_tapped_journal: return "home_tapped_journal"
        case .home_tapped_recent_meditation: return "home_tapped_recent_meditation"
        case .home_tapped_favorite_meditation: return "home_tapped_favorite_meditation"
        case .home_tapped_floatingMenu: return "home_tapped_floatingMenu"
        case .home_tapped_bonus: return "home_tapped_bonus"
        case .home_tapped_streak: return "home_tapped_streak"
        case .home_tapped_real_tree: return "home_tapped_real_tree"
        case .home_claim_daily: return "home_claim_daily:"
        case .home_claim_seven: return "home_claim_seven"
        case .home_claim_thirty: return "home_claim_thirty"
        case .home_tapped_new_meditation: return "home_tapped_new_meditation"
        case .home_tapped_weekly_meditation: return "home_tapped_weekly_meditation"
        case .home_selected_mood: return "home_selected_mood"
        case .challenge_tapped_x: return "challenge_tapped_x"
        case .challenge_tapped_accept: return "challenge_tapped_accept"
        case .IAP_tapped_freeze: return "IAP_tapped_freeze"
        case .IAP_tapped_potion: return "IAP_tapped_potion"
        case .IAP_tapped_chest: return "IAP_tapped_chest"
        case .home_tapped_IAP: return "home_tapped_IAP"
        case .screen_load_store: return "screen_load_store"
        case .store_tapped_plant_tile: return "store_tapped_plant_tile"
        case .screen_load_plant_select: return "screen_load_plant_select"
        case .selected_plant: return "selected_plant"
        case .screen_load_badge: return "screen_load_badge"
        case .screen_load_shop_page: return "screen_load_shop_page"
        case .screen_load_real_tree: return "screen_load_real_tree"
        case .store_tapped_purchase_modal_buy: return "store_tapped_purchase_modal_buy"
        case .store_tapped_confirm_modal_confirm: return "store_tapped_confirm_modal_confirm"
        case .store_tapped_confirm_modal_cancel: return "store_tapped_confirm_modal_cancel"
        case .store_tapped_success_modal_okay: return "store_tapped_success_modal_okay"
        case .store_tapped_rate_app: return "store_tapped_rate_app"
        case .store_tapped_refer_friend: return "store_tapped_refer_friend"
        case .store_tapped_go_pro: return "store_tapped_go_pro"
        case .store_tapped_discord: return "store_tapped_discord"
        case .store_tapped_badge_tile: return "store_tapped_badge_tile"
        case .store_tapped_buy_real_tree: return "store_tapped_buy_real_tree"
        case .store_animation_continue: return "store_animation_continue"
        case .notification_success_store: return "notification_success_store"
        case .notification_settings_store: return "notification_settings_store"
        case .screen_load_middle: return "screen_load_middle"
        case .middle_tapped_favorite: return "middle_tapped_favorite"
        case .middle_tapped_unfavorite: return "middle_tapped_unfavorite"
        case .middle_tapped_back: return "middle_tapped_back"
        case .middle_tapped_recommended: return "middle_tapped_recommended"
        case .middle_tapped_row: return "middle_tapped_row"
        case .middle_tapped_row_favorite: return "middle_tapped_row_favorite"
        case .middle_tapped_row_unfavorite: return "middle_tapped_row_unfavorite"
        case .middle_tapped_locked_recommended: return "middle_tapped_locked_recommended"
        case .middle_tapped_plant_select: return "middle_tapped_plant_select"
        case .screen_load_play: return "screen_load_play"
        case .play_tapped_back: return "play_tapped_back"
        case .play_tapped_favorite: return "play_tapped_favorite"
        case .play_tapped_unfavorite: return "play_tapped_unfavorite"
        case .play_tapped_sound: return "play_tapped_sound"
        case .play_tapped_sound_rain: return "play_tapped_sound_rain"
        case .play_tapped_sound_night: return "play_tapped_sound_night"
        case .play_tapped_sound_nature: return "play_tapped_sound_nature"
        case .play_tapped_sound_fire: return "play_tapped_sound_fire"
        case .play_tapped_sound_noSound: return "play_tapped_sound_noSound"
        case .play_tapped_hz: return "play_tapped_hz"
        case .play_tapped_instrument: return "play_tapped_instrument"
        case .screen_load_finished: return "screen_load_finished"
        case .finished_save_progress: return "finished_save_progress"
        case .finished_not_now: return "finished_not_now"
        case .finished_tapped_share: return "finished_tapped_share"
        case .finished_set_reminder: return "finished_set_reminder"
        case .finished_tapped_favorite: return "finished_tapped_favorite"
        case .finished_tapped_unfavorite: return "finished_tapped_unfavorite"
        case .finished_tapped_finished: return "finished_tapped_finished"
        case .finished_tapped_mood: return "finished_tapped_mood"
        case .finished_tapped_gratitude: return "finished_tapped_gratitude"
        case .screen_load_profile: return "screen_load_profile"
        case .profile_tapped_profile: return "profile_tapped_profile"
        case .profile_tapped_settings: return "profile_tapped_settings"
        case .profile_tapped_email: return "profile_tapped_email"
        case .profile_tapped_discord: return "profile_tapped_discord"
        case .profile_tapped_invite: return "profile_tapped_invite"
        case .profile_tapped_notifications: return "profile_tapped_notifications"
        case .profile_tapped_instagram: return "profile_tapped_instagram"
        case .profile_tapped_restore: return "profile_tapped_restore"
        case .profile_tapped_toggle_off_notifs: return "profile_tapped_toggle_off_notifs"
        case .profile_tapped_toggle_on_notifs: return "profile_tapped_toggle_on_notifs"
        case .profile_tapped_toggle_off_mindful: return "profile_tapped_toggle_on_mindful"
        case .profile_tapped_toggle_on_mindful: return "profile_tapped_toggle_off_mindful"
        case .profile_tapped_logout: return "profile_tapped_logout"
        case .profile_tapped_feedback: return "profile_tapped_feedback"
        case .profile_tapped_roadmap: return "profile_tapped_roadmap"
        case .profile_tapped_goPro: return "profile_tapped_goPro"
        case .profile_tapped_refer_friend: return "profile_tapped_refer_friend"
        case .profile_tapped_refer: return "profile_tapped_refer_friend"
        case .profile_tapped_rate: return "profile_tapped_rate"
        case .profile_tapped_create_account: return "profile_tapped_create_account"
        case .profile_tapped_add_widget: return "profile_tapped_add_widget"
        case .profile_tapped_delete_account: return "profile_tapped_delete_account"
        case .profile_tapped_garden: return "profile_tapped_garden"
        case .profile_tapped_garden_date_on: return "profile_tapped_garden_date_on"
        case .profile_tapped_garden_date_off: return "profile_tapped_garden_date_off"
        case .profile_tapped_background_on: return "profile_tapped_background_on"
        case .profile_tapped_background_off: return "profile_tapped_background_off"
        case .screen_load_categories: return "screen_load_categories"
        case .categories_tapped_square: return "categories_tapped_square"
        case .categories_tapped_unguided: return "categories_tapped_unguided"
        case .categories_tapped_all: return "categories_tapped_all"
        case .categories_tapped_courses: return "categories_tapped_courses"
        case .categories_tapped_anxiety: return "categories_tapped_anxiety"
        case .categories_tapped_focus: return "categories_tapped_focus"
        case .categories_tapped_growth: return "categories_tapped_growth"
        case .categories_tapped_meditation: return "categories_tapped_meditation"
        case .categories_tapped_sleep: return "categories_tapped_sleep"
        case .categories_tapped_confidence: return "categories_tapped_confidence"
        case .categories_tapped_locked_meditation: return "categories_tapped_locked_meditation"
        case .categories_tapped_request: return "categories_tapped_request"
        case .tabs_tapped_meditate: return "tabs_tapped_meditate"
        case .tabs_tapped_garden: return "tabs_tapped_garden"
        case .tabs_tapped_store: return "tabs_tapped_store"
        case .tabs_tapped_profile: return "tabs_tapped_profile"
        case .tabs_tapped_plus: return "tabs_tapped_plus"
        case .tabs_tapped_search: return "tabs_tapped_search"
        case .plus_tapped_mood: return "plus_tapped_mood"
        case .mood_tapped_angry: return "mood_tapped_angry"
        case .mood_tapped_sad: return "mood_tapped_sad"
        case .mood_tapped_okay: return "mood_tapped_okay"
        case .mood_tapped_happy: return "mood_tapped_happy"
        case .mood_tapped_stress: return "mood_tapped_stress"
        case .mood_tapped_good: return "mood_tapped_good"
        case .mood_tapped_veryGood: return "mood_tapped_veryGood"
        case .mood_tapped_bad: return "mood_tapped_bad"
        case .mood_tapped_veryBad: return "mood_tapped_veryBad"
        case .plus_selected_mood: return "plus_selected_mood"
        case .mood_tapped_x: return "mood_tapped_x"
        case .mood_tapped_done: return "mood_tapped_done"
        case .plus_tapped_gratitude: return "plus_tapped_gratitude"
        case .plus_tapped_mood_to_pricing: return "plus_tapped_mood_to_pricing"
        case .plus_tapped_gratitude_to_pricing: return "plus_tapped_gratitude_to_pricing"
        case .plus_tapped_meditate_to_pricing: return "plus_tapped_meditate_to_pricing"
        case .gratitude_tapped_done: return "gratitude_tapped_done"
        case .gratitude_tapped_cancel: return "gratitude_tapped_cancel"
        case .gratitude_tapped_prompts: return "gratitude_tapped_prompts"
        case .plus_tapped_meditate: return "plus_tapped_meditate"
        case .play_tapped_sound_beach: return "play_tapped_sound_beach"
        case .seventh_time_coming_back: return "seventh_time_coming_back"
        case .screen_load_pricing: return "screen_load_pricing"
        case .screen_load_14pricing: return "screen_load_14pricing"
        case .pricing_from_home: return "pricing_from_home"
        case .pricing_from_locked: return "pricing_from_locked"
        case .pricing_from_profile: return "pricing_from_profile"
        case .pricing_from_store: return "pricing_from_store"
        case .pricing_tapped_notif_ok: return "pricing_tapped_notif_ok"
        case .pricing_tapped_notif_not_now: return "pricing_tapped_notif_not_now"
        case .pricing_notif_accepted: return "pricing_notif_accepted"
        case .pricing_notif_denied: return "pricing_notif_denied"
        case .screen_load_review: return "screen_load_review"
        case .review_tapped_tutorial: return "review_tapped_tutorial"
        case .review_tapped_explore: return "review_tapped_explore"
        case .review_notification_on: return "review_notification_on"
        case .review_notification_off: return "review_notification_off"
        case .screen_load_learn: return "screen_load_learn"
        case .notification_success_learn: return "notification_success_learn"
        case .notification_settings_learn: return "notification_settings_learn"
        case .notification_tapped_intro_reminder: return "notification_tapped_intro_reminder"
        case .notification_tapped_oneDay_reminder: return "notification_tapped_oneDay_reminder"
        case .notification_tapped_threeDay_reminder: return "notification_tapped_threeDay_reminder"
        case .notification_tapped_streakNotStarted: return "notification_tapped_streakNotStarted"
        case .notification_tapped_onboarding: return "notification_tapped_onboarding"
        case .notification_tapped_widget: return "notification_tapped_widget"
        case .notification_tapped_store: return "notification_tapped_store"
        case .notification_tapped_learn: return "notification_tapped_learn"
        case .learn_tapped_meditation_course: return "learn_tapped_meditation_course"
        case .learn_finished_meditation_course: return "learn_finished_meditation_course"
        
        case .learn_tapped_life_course: return "learn_tapped_life_course"
        case .learn_finished_life_course: return "learn_finished_life_course"
        case .screen_load_single: return "screen_load_single"
        case .screen_load_single_onboarding: return "screen_load_single_onboarding"
        case .screen_load_superwall: return "screen_load_superwall"
        case .yearly_started_from_superwall: return "yearly_started_from_superwall"
        case .monthly_started_from_superwall: return "monthly_started_from_superwall"
        case .screen_load_50pricing: return "screen_load_50pricing"
        case .home_tapped_locked_meditation: return "home_tapped_locked_meditation"
        case .modal_50_not_now: return "modal_50_not_now"
        case .story_notification_swipe: return "story_notification_swipe"
        case .story_comic_opened: return "story_comic_opened"
        case .story_bijan_opened: return "story_bijan_opened"
        case .story_journal_opened: return "story_journal_opened"
        case .story_quote_opened: return "story_quote_opened"
        case .story_tip_opened: return "story_tip_opened"
        case .story_notification_swipe_gratitude: return "story_notification_swipe_gratitude"
        case .story_swipe_trees_future: return "story_swipe_trees_future"
        case .store_bought_real_tree: return "store_bought_real_tree"
        case .no_thanks_50: return "no_thanks_50"
        
        case .screen_load_discover: return "screen_load_discover"
        case .screen_load_journey: return "screen_load_journey"
        case .discover_tapped_search: return "discover_tapped_search"
        case .user_from_influencer: return "user_from_influencer"
        case .discover_tapped_journey_med: return "discover_tapped_journey_med"
        case .home_tapped_journey_med: return "home_tapped_journey_med"
            
        //MARK: - Next Steps
        case .screen_load_nextsteps: return "screen_load_nextsteps"
        case .nextsteps_created_reminder: return "nextsteps_created_reminder"
        case .nextsteps_tapped_save_progress: return "nextsteps_tapped_save_progress"
        case .nextsteps_tapped_done: return "nextsteps_tapped_done"
            
        //MARK: - Streak
        case .screen_load_streak: return "screen_load_streak" //
        case .rating_tapped_yes: return "rating_tapped_yes" //
        case .rating_tapped_no: return "rating_tapped_no" //
        
        //MARK: - Recs
        case .screen_load_recs: return "screen_load_recs"
        case .onboarding_load_recs: return "onboarding_load_recs"
        case .recs_tapped_see_more: return "recs_tapped_see_more"
        case .onboarding_tapped_30_second: return "onboarding_tapped_30_second"
        case .recommendations_tapped_breath: return "recommendations_tapped_breath"
        case .recommendations_tapped_med: return "recommendations_tapped_med"
        case .recommendations_tapped_x: return "recommendations_tapped_med"
        
        //MARK: - Mood
        case .screen_load_mood_elaborate: return "screen_load_mood_elaborate"
        case .elaborate_tapped_edit: return "elaborate_tapped_edit"
        case .elaborate_add_new_mood: return "elaborate_add_new_mood"
        case .elaborate_delete_mood: return "elaborate_delete_mood"
        
        //MARK: - Journal
        case .screen_load_journal: return "screen_load_journal"
        case .journal_tapped_done: return "journal_tapped_done"
        case .journal_tapped_prompts: return "journal_tapped_prompts"
        case .journal_tapped_shuffle: return "journal_tapped_shuffle"
        case .journal_tapped_x: return "journal_tapped_x"
            
        case .update_triggered_auth: return "update_triggered_auth"
        case .show_onboarding_auth: return "show_onboarding_auth"
            
        //MARK: - widget
        case .widget_tapped_no_thanks: return "widget_tapped_no_thanks"
        case .widget_tapped_finished: return "widget_tapped_finished"
        case .widget_tapped_breathwork: return "widget_tapped_breathwork"
        case .widget_tapped_meditate: return "widget_tapped_meditate"
        case .widget_tapped_logMood: return "widget_tapped_logMood"
        case .widget_tapped_journal: return "widget_tapped_journal"
        }
    }
}
