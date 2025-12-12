import SwiftUI

struct AboutView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.xLarge) {
                    medicalDisclaimerSection
                    privacyPolicySection
                }
                .padding(.horizontal, AppSpacing.large)
                .padding(.vertical, AppSpacing.xLarge)
            }
            .background(AppColors.background.ignoresSafeArea())
            .navigationTitle("About")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .font(AppTypography.callout)
                }
            }
        }
    }
    
    // MARK: - Medical Disclaimer Section
    private var medicalDisclaimerSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.medium) {
            Text("Medical Disclaimer")
                .font(AppTypography.title1)
                .foregroundStyle(AppColors.primaryText)
            
            HandDrawnCard {
                VStack(alignment: .leading, spacing: AppSpacing.medium) {
                    Text(medicalDisclaimerText)
                        .font(AppTypography.body)
                        .foregroundStyle(AppColors.primaryText)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
    }
    
    // MARK: - Privacy Policy Section
    private var privacyPolicySection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.medium) {
            Text("Privacy Policy")
                .font(AppTypography.title1)
                .foregroundStyle(AppColors.primaryText)
            
            HandDrawnCard {
                VStack(alignment: .leading, spacing: AppSpacing.medium) {
                    Text(privacyPolicyText)
                        .font(AppTypography.body)
                        .foregroundStyle(AppColors.primaryText)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
    }
    
    // MARK: - Medical Disclaimer Text
    private var medicalDisclaimerText: String {
        """
        IMPORTANT MEDICAL DISCLAIMER
        
        The information provided in this application, including but not limited to content related to cravings explanation, quit smoking guidance, health progress tracking, and educational materials, is for informational and motivational purposes only. This application is not intended to be a substitute for professional medical advice, diagnosis, or treatment.
        
        Always seek the advice of your physician or other qualified health provider with any questions you may have regarding a medical condition or smoking cessation. Never disregard professional medical advice or delay in seeking it because of something you have read or learned through this application.
        
        The content provided in this application, including health-related information, statistics, and guidance, is based on general knowledge and should not be considered as personalized medical advice. Individual results may vary, and the information presented may not be applicable to your specific health situation.
        
        If you think you may have a medical emergency, call your doctor or emergency services immediately. This application does not provide emergency medical services.
        
        The developers and operators of this application make no representations or warranties of any kind, express or implied, about the completeness, accuracy, reliability, suitability, or availability of the information contained in this application. Any reliance you place on such information is strictly at your own risk.
        
        By using this application, you acknowledge that you have read, understood, and agree to this medical disclaimer.
        
        Last updated: December 2025
        """
    }
    
    // MARK: - Privacy Policy Text
    private var privacyPolicyText: String {
        """
        PRIVACY POLICY
        
        Last Updated: December 2025
        
        Nicoboo ("we," "our," or "us") is committed to protecting your privacy. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our mobile application.
        
        1. INFORMATION WE COLLECT
        
        We collect information that you provide directly to us, including:
        - Account information (email address, if you choose to create an account)
        - Smoking/vaping habits and preferences
        - Quit date and progress tracking data
        - Achievement and goal information
        - Any other information you choose to provide
        
        We also automatically collect certain information when you use our app:
        - Device information (device type, operating system)
        - Usage data (features used, time spent in app)
        - Analytics data (app crashes, performance metrics)
        
        2. HOW WE USE YOUR INFORMATION
        
        We use the information we collect to:
        - Provide, maintain, and improve our services
        - Personalize your experience and deliver relevant content
        - Track your progress and calculate statistics
        - Send you notifications and updates (if enabled)
        - Analyze usage patterns to improve app functionality
        - Comply with legal obligations
        
        3. DATA STORAGE AND SECURITY
        
        Your data is stored using:
        - Local device storage (SwiftData) for app functionality
        - Firebase Authentication and Firestore (if you create an account) for cloud synchronization
        
        We implement appropriate technical and organizational measures to protect your personal information. However, no method of transmission over the internet or electronic storage is 100% secure.
        
        4. DATA SHARING AND DISCLOSURE
        
        We do not sell, trade, or rent your personal information to third parties. We may share your information only in the following circumstances:
        - With your explicit consent
        - To comply with legal obligations
        - To protect our rights and safety
        - With service providers who assist us in operating our app (e.g., Firebase, analytics providers)
        
        5. YOUR RIGHTS
        
        You have the right to:
        - Access your personal information
        - Correct inaccurate information
        - Delete your account and associated data
        - Opt-out of certain data collection practices
        - Export your data
        
        To exercise these rights, please contact us through the app or via email.
        
        6. CHILDREN'S PRIVACY
        
        Our app is not intended for children under the age of 13. We do not knowingly collect personal information from children under 13.
        
        7. CHANGES TO THIS PRIVACY POLICY
        
        We may update this Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page and updating the "Last Updated" date.
        
        8. CONTACT US
        
        If you have any questions about this Privacy Policy, please contact us through the app or via email.
        
        By using Nicoboo, you consent to the collection and use of information in accordance with this Privacy Policy.
        """
    }
}

#Preview {
    AboutView()
}

