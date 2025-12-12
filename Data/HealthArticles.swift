// HealthArticles.swift
// Smoke-free education articles for the app

import Foundation

struct HealthArticle: Identifiable {
    let id: Int
    let title: String
    let content: String
    let imageName: String // Image asset name from Assets.xcassets
}

let healthArticles: [HealthArticle] = [
    HealthArticle(
        id: 1,
        title: "The Real Impact of Smoking on Your Body",
        content: """
The effects of smoking on the body often don't show up immediately. Instead, they work slowly, like an invisible force quietly changing how your organs function. Nicotine in cigarettes raises your heart rate and blood pressure, putting your body into a constant state of tension. More concerning is that cigarette smoke contains thousands of chemicals, dozens of which are known to damage lung cells.

When smoke enters the lungs, the tiny cilia—responsible for cleaning out dust and bacteria—become temporarily paralyzed. This makes it harder for the lungs to remove harmful substances. Over time, lung capacity decreases, and breathing becomes more difficult. At the same time, smoking causes blood vessels to narrow, increasing the risk of heart disease, stroke, and circulation problems.

The good news is that the body begins to recover surprisingly quickly once you quit. Just 20 minutes after stopping, your heart rate begins to drop. Within 12 hours, carbon monoxide levels in your blood return to normal. After a few weeks, breathing becomes easier and physical endurance improves. Quitting doesn't make everything better overnight, but it makes you healthier every single day.

No matter when you choose to quit, it is never too late. Your body will thank you faster than you think.
""",
        imageName: "image-a15"
    ),
    HealthArticle(
        id: 2,
        title: "Why Craving a Cigarette Is Often a False Signal",
        content: """
Many people believe they "can't live without cigarettes," but in reality, cravings are often the result of learned habits rather than actual physical need. When nicotine enters the body, it triggers the release of dopamine in the brain, creating brief feelings of relaxation or pleasure. Over time, the brain links "smoking" with "feeling better," so whenever you feel stressed or bored, it sends the wrong signal.

These cravings may feel powerful, but they are short-lived. Most craving peaks last only 3 to 5 minutes. If you can distract yourself—drink water, stretch, breathe deeply—the urge naturally fades. Many people are surprised to discover after quitting: "My body wasn't the problem. It was the habit."

More importantly, the body begins healing from day one of quitting. Blood circulation improves, sleep quality increases, coughs become less frequent, and skin gradually becomes clearer. These improvements help you realize that the brain has been mistaken in pairing "smoking = comfort."

When you quit smoking, you are not fighting against yourself. You are simply giving your body time to return to the way it was meant to function—healthy, calm, and free. Quitting doesn't demand that you become stronger; it simply allows you to become yourself again.
""",
        imageName: "image-a20"
    ),
    HealthArticle(
        id: 3,
        title: "The Financial Cost of Smoking: More Than Just Money",
        content: """
Many people focus on the health risks of smoking, but the financial impact is equally significant and often more immediate. The cost of cigarettes adds up quickly—what seems like a small daily expense can become thousands of dollars per year. But the financial burden extends far beyond the price of cigarettes themselves.

Smoking increases healthcare costs, insurance premiums, and can even affect your career opportunities. Many employers now offer better benefits to non-smokers, and some charge higher insurance premiums for smokers. The money spent on cigarettes could instead be invested in experiences, savings, or items that bring genuine joy and fulfillment.

Calculating your personal savings can be a powerful motivator. When you see how much money you're saving each day, week, and month, it becomes tangible proof of your progress. This isn't just about numbers—it's about reclaiming financial freedom and redirecting resources toward what truly matters to you.

Every cigarette you don't smoke is money back in your pocket, and every day you stay smoke-free is an investment in your future.
""",
        imageName: "image-a25"
    ),
    HealthArticle(
        id: 4,
        title: "Building New Habits: Replacing Smoking with Positive Actions",
        content: """
Quitting smoking isn't just about stopping a bad habit—it's about creating space for new, positive habits that support your well-being. The time and energy you once spent on smoking can be redirected toward activities that genuinely improve your life.

Physical activity is one of the most effective replacements. Exercise releases endorphins, reduces stress, and helps your body recover from the effects of smoking. Even a short walk can help when cravings strike. Many people find that their fitness improves dramatically after quitting, which becomes its own reward.

Mindfulness and breathing exercises can also fill the gaps left by smoking. Deep breathing not only helps with cravings but also improves lung function and reduces anxiety. Meditation or simple moments of quiet reflection can provide the mental break that smoking once offered, but in a healthier way.

Social connections are another powerful tool. Spending time with supportive friends and family, joining a support group, or engaging in hobbies can replace the social aspects of smoking. Building these new habits takes time, but each positive action strengthens your commitment to a smoke-free life.
""",
        imageName: "image-a30"
    ),
    HealthArticle(
        id: 5,
        title: "Understanding Withdrawal: What to Expect and How to Cope",
        content: """
Nicotine withdrawal is a real and challenging part of quitting, but understanding what to expect can help you prepare and succeed. Withdrawal symptoms typically peak within the first few days and gradually decrease over the following weeks. Common symptoms include irritability, difficulty concentrating, increased appetite, and sleep disturbances.

The good news is that these symptoms are temporary and manageable. Most physical withdrawal symptoms subside within a week, while psychological cravings may persist longer. Remember that each craving is a sign that your body is healing and adjusting to life without nicotine.

Staying hydrated, eating regular meals, and getting enough sleep can help manage withdrawal symptoms. Avoiding triggers like alcohol, caffeine, or stressful situations in the early days can also make the process smoother. Some people find nicotine replacement therapy helpful, while others prefer to quit cold turkey.

The intensity of withdrawal varies from person to person, but it's important to remember that it's a normal part of the process. Every moment of discomfort is a step toward freedom. You're not weak for experiencing withdrawal—you're strong for pushing through it.
""",
        imageName: "image-a35"
    ),
    HealthArticle(
        id: 6,
        title: "The Social and Environmental Impact of Quitting",
        content: """
Your decision to quit smoking extends far beyond personal health—it positively impacts those around you and the environment. Secondhand smoke affects family members, friends, and even pets. By quitting, you're protecting the health of everyone in your life, especially children who are particularly vulnerable to the effects of secondhand smoke.

The environmental impact of smoking is also significant. Cigarette butts are the most littered item in the world, taking years to decompose and releasing harmful chemicals into soil and water. The production of cigarettes requires vast amounts of water, pesticides, and contributes to deforestation. By quitting, you're reducing your environmental footprint in a meaningful way.

Socially, quitting can improve your relationships. Many non-smokers find the smell of smoke unpleasant, and smoking can create barriers in social situations. Being smoke-free opens up new opportunities for connection and participation in activities that might have been limited before.

Your choice to quit is a gift to yourself, your loved ones, and the world around you. Every day you stay smoke-free, you're making a positive difference that extends far beyond your own life.
""",
        imageName: "image-a40"
    )
]

