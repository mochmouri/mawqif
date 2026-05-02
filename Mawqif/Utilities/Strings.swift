import Foundation

// MARK: - Language

enum AppLanguage: String, CaseIterable {
    case english = "en"
    case arabic  = "ar"

    var displayLabel: String {
        switch self {
        case .english: return "AR"   // button shows the other language
        case .arabic:  return "EN"
        }
    }

    var toggled: AppLanguage {
        self == .english ? .arabic : .english
    }
}

// MARK: - Localized strings

struct S {
    let appName: String
    let appSubtitle: String

    // Status labels
    let statusScanning: String
    let statusFreeHours: String
    let statusParked: String
    let statusPayNow: String
    let statusUnpaid: String
    let statusPaid: String
    let statusNoZone: String

    // Timer section
    let parkedFor: String
    let gracePeriod: String
    let inGrace: String
    let graceExpired: String
    let graceRemaining: String
    let timeRemaining: String

    // Buttons
    let btnIPaid: String
    let btnStop: String
    let btnPayNow: String
    let btnEnableLocation: String
    let btnOpenSettings: String

    // Permission screen
    let permTitle: String
    let permBody: String
    let permAlways: String
    let permNote: String

    // Zone info
    let zoneLabel: String
    let rateLabel: String
    let hoursLabel: String
    let noZoneNearby: String
    let freeUntil: String
    let zones147: String

    // GPS
    let gpsSearching: String
    let gpsActive: String
    let gpsNoPermission: String

    // Activity
    let activityTitle: String
    let activityEmpty: String
    let enteredZone: String
    let leftZone: String
    let sessionStopped: String
    let markedPaid: String

    // Notifications (in-app)
    let notif5min: String
    let notif10min: String

    // Days / hours
    let freeDays: String

    static let english = S(
        appName: "Mawqif",
        appSubtitle: "147 zones · 3.45 SAR/hr · 8AM–12AM",
        statusScanning: "Scanning",
        statusFreeHours: "Free Hours",
        statusParked: "Parked",
        statusPayNow: "Pay Now",
        statusUnpaid: "Unpaid!",
        statusPaid: "Paid",
        statusNoZone: "No Paid Zone",
        parkedFor: "PARKED FOR",
        gracePeriod: "Grace period",
        inGrace: "In grace period",
        graceExpired: "Grace period expired",
        graceRemaining: "remaining",
        timeRemaining: "TIME REMAINING",
        btnIPaid: "I Paid",
        btnStop: "Stop Session",
        btnPayNow: "Pay Now",
        btnEnableLocation: "Enable Location",
        btnOpenSettings: "Open Settings",
        permTitle: "Location Access Needed",
        permBody: "Mawqif monitors your location in the background to detect paid parking zones and remind you before your grace period ends.",
        permAlways: "Allow Always",
        permNote: "Your location is only used to check nearby parking zones. It is never shared.",
        zoneLabel: "ZONE",
        rateLabel: "3.45 SAR/hr",
        hoursLabel: "8:00 AM – 12:00 AM",
        noZoneNearby: "No paid zone detected nearby",
        freeUntil: "Free until 8:00 AM",
        zones147: "147 zones monitored",
        gpsSearching: "Acquiring GPS…",
        gpsActive: "GPS active",
        gpsNoPermission: "Location permission required",
        activityTitle: "ACTIVITY LOG",
        activityEmpty: "No activity yet. Drive into a paid zone to start.",
        enteredZone: "Entered paid zone",
        leftZone: "Left paid zone",
        sessionStopped: "Session stopped",
        markedPaid: "Marked as paid",
        notif5min: "Parked for 5 minutes. Did you pay? 3.45 SAR/hr",
        notif10min: "Grace period ends in 5 minutes!",
        freeDays: "Free on Fridays & holidays"
    )

    static let arabic = S(
        appName: "مواقف",
        appSubtitle: "١٤٧ منطقة · ٣٫٤٥ ريال/ساعة · ٨ص–١٢م",
        statusScanning: "جاري البحث",
        statusFreeHours: "وقت مجاني",
        statusParked: "موقوف",
        statusPayNow: "ادفع الآن",
        statusUnpaid: "غير مدفوع!",
        statusPaid: "مدفوع",
        statusNoZone: "لا توجد منطقة مدفوعة",
        parkedFor: "مدة الوقوف",
        gracePeriod: "فترة السماح",
        inGrace: "ضمن فترة السماح",
        graceExpired: "انتهت فترة السماح",
        graceRemaining: "متبقي",
        timeRemaining: "الوقت المتبقي",
        btnIPaid: "دفعت",
        btnStop: "إيقاف الجلسة",
        btnPayNow: "ادفع الآن",
        btnEnableLocation: "تفعيل الموقع",
        btnOpenSettings: "فتح الإعدادات",
        permTitle: "مطلوب إذن الموقع",
        permBody: "مواقف يراقب موقعك في الخلفية للكشف عن مناطق الوقوف المدفوعة وتذكيرك قبل انتهاء فترة السماح.",
        permAlways: "السماح دائماً",
        permNote: "موقعك يُستخدم فقط للتحقق من مناطق الوقوف القريبة، ولا يُشارك مع أي جهة.",
        zoneLabel: "المنطقة",
        rateLabel: "٣٫٤٥ ريال/ساعة",
        hoursLabel: "٨:٠٠ ص – ١٢:٠٠ م",
        noZoneNearby: "لا توجد منطقة وقوف مدفوعة قريبة",
        freeUntil: "مجاني حتى ٨:٠٠ صباحاً",
        zones147: "١٤٧ منطقة مراقبة",
        gpsSearching: "جاري تحديد الموقع…",
        gpsActive: "GPS نشط",
        gpsNoPermission: "مطلوب إذن الموقع",
        activityTitle: "سجل النشاط",
        activityEmpty: "لا يوجد نشاط بعد. ادخل منطقة وقوف مدفوعة للبدء.",
        enteredZone: "دخلت منطقة مدفوعة",
        leftZone: "غادرت المنطقة",
        sessionStopped: "تم إيقاف الجلسة",
        markedPaid: "تم تسجيل الدفع",
        notif5min: "وقفت ٥ دقائق. هل دفعت؟ ٣٫٤٥ ريال/ساعة",
        notif10min: "فترة السماح تنتهي بعد ٥ دقائق!",
        freeDays: "مجاني أيام الجمعة والعطل الرسمية"
    )
}
