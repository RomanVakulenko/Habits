import UIKit

/// Класс для хранения данных о привычке.
public final class Habit: Codable {

    /// Название привычки.
    public var name: String

    /// Время выполнения привычки.
    public var date: Date

    /// Даты выполнения привычки.
    public var trackDates: [Date]

    /// Цвет привычки для выделения в списке.
    public var color: UIColor {
        get {
            return .init(red: r, green: g, blue: b, alpha: a)
        }
        set {
            var r: CGFloat = 0
            var g: CGFloat = 0
            var b: CGFloat = 0
            var a: CGFloat = 0
            newValue.getRed(&r, green: &g, blue: &b, alpha: &a)
            self.r = r
            self.g = g
            self.b = b
            self.a = a
        }
    }

    /// Описание времени выполнения привычки.
    public var dateString: String {
        "Каждый день в " +  Format.timeForHabitRepeats.string(from: date)
    }

    /// Показывает, была ли сегодня добавлена привычка.
    public var isAlreadyTakenToday: Bool {
        guard let lastTrackDate = trackDates.last else {
            return false
        }
        return calendar.isDateInToday(lastTrackDate)
    }

    private var r: CGFloat
    private var g: CGFloat
    private var b: CGFloat
    private var a: CGFloat

    private lazy var calendar: Calendar = .current

    public init(name: String, date: Date, trackDates: [Date] = [], color: UIColor) {
        self.name = name
        self.date = date
        self.trackDates = trackDates
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        self.r = r
        self.g = g
        self.b = b
        self.a = a
    }
}

extension Habit: Equatable {

    public static func == (lhs: Habit, rhs: Habit) -> Bool {
        lhs.name == rhs.name &&
        lhs.date == rhs.date &&
        lhs.trackDates == rhs.trackDates &&
        lhs.r == rhs.r &&
        lhs.g == rhs.g &&
        lhs.b == rhs.b &&
        lhs.a == rhs.a
    }
}

/// Класс для сохранения и изменения привычек пользователя.
public final class HabitsStore {

    /// Синглтон для изменения состояния привычек из разных модулей.
    public static let shared: HabitsStore = .init()

    /// Список привычек, добавленных пользователем. Добавленные привычки сохраняются в UserDefaults и доступны после перезагрузки приложения.
    public var habits: [Habit] = [] {
        didSet {
            save()
        }
    }

    /// Даты с момента установки приложения с разницей в один день.
    public var dates: [Date] {
        guard let startDate = userDefaults.object(forKey: "start_date") as? Date else {
            return []
        }
        return Date.dates(from: startDate, to: .init())
    }

    /// Возвращает значение от 0 до 1.
    public var todayProgress: Float {
        guard habits.isEmpty == false else {
            return 0
        }
        let habitsTakenToday = habits.filter { $0.isAlreadyTakenToday }
        return Float(habitsTakenToday.count) / Float(habits.count)
    }

    private lazy var userDefaults: UserDefaults = .standard

    private lazy var decoder: JSONDecoder = .init()

    private lazy var encoder: JSONEncoder = .init()

    private lazy var calendar: Calendar = .current

    // MARK: - Lifecycle

    /// Сохраняет все изменения в привычках в UserDefaults.
    public func save() {
        do {
            let data = try encoder.encode(habits)
            userDefaults.set(data, forKey: "habits")
        }
        catch {
            print("Ошибка кодирования привычек для сохранения", error)
        }
    }

    /// Добавляет текущую дату в trackDates для переданной привычки.
    /// - Parameter habit: Привычка, в которую добавится новая дата.
    public func track(_ habit: Habit) {
        habit.trackDates.append(.init())
        save()
    }

    /// Показывает, была ли затрекана привычка в переданную дату.
    /// - Parameters:
    ///   - habit: Привычка, у которой проверяются затреканные даты.
    ///   - date: Дата, для которой проверяется, была ли затрекана привычка.
    /// - Returns: Возвращает true, если привычка была затрекана в переданную дату.
    public func habit(_ habit: Habit, isTrackedIn date: Date) -> Bool {
        habit.trackDates.contains { trackDate in
            calendar.isDate(date, equalTo: trackDate, toGranularity: .day)
        }

    }

    // MARK: - Private

    private init() {
        if userDefaults.object(forKey: "start_date") == nil {
            let startDate = calendar.date(from: calendar.dateComponents([.year, .month, .day], from: Date())) ?? Date()
            userDefaults.set(startDate, forKey: "start_date")
        }
        guard let data = userDefaults.data(forKey: "habits") else { return }
        do {
            habits = try decoder.decode([Habit].self, from: data)
        }
        catch {
            print("Ошибка декодирования сохранённых привычек", error)
        }
    }
}

private extension Date {

    static func dates(from fromDate: Date, to toDate: Date) -> [Date] {
        var dates: [Date] = []
        var date = fromDate

        while Calendar.current.compare(date, to: toDate, toGranularity: .day) != .orderedDescending {
            dates.append(date)
            guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else {
                break
            }
            date = newDate
        }

        return dates
    }
}
