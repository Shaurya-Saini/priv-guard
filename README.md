# PrivGuard – AI Personal Privacy Risk Analyzer

PrivGuard is a mobile-first, privacy-focused app that helps users detect **oversharing risks** in their digital content. Whether it’s social media posts, images, or bios, PrivGuard uses **custom on-device AI** to analyze content and flag potential **privacy threats**, ensuring your data **never leaves your phone** or trusted backend.

---

## 🌐 Real-World Use Case

> Over 90% of digital threats begin with publicly available data.

PrivGuard educates and protects users by identifying:
- Posts that reveal personal details
- Real-time travel or location risks
- Information linked to password recovery
- IDs, documents, tickets captured in photos

---

## 🔒 Example Privacy Risks Detected
1. Location check-ins & travel posts
2. Birthdays, graduations, event shares
3. Visible IDs, tickets, addresses in media
4. Other important personal detials that might put the user at risk if publically available

---

## 📱 Core Features

### Upload & Local Scan
- Capture or upload media/text posts
- Securly save to local storage
- Long-press to run on-device scan

### AI Privacy Analysis
- **Text classifier**: NER-based risk labeling with DistilBERT
- **Risk Score**: 0–100 with 🟢 Low, 🟡 Medium, 🔴 High tag
- **Smart Tips**: Context-aware advice (e.g., mask phone numbers, generalise location)
- **Image Scanning**: Object detection to extract and detect any risky details from image post (AVAILABLE IN FUTURE VERSIONS)

### Social Profile Risk Scanner (AVAILABLE IN FUTURE VERSIONS)
- Input Instagram/Twitter handle + email
- Uses `Instaloader` / `snscrape` to fetch data
- NLP analysis of bio, captions, hashtags
- Sends email report via SMTP or Firebase
- Auto-rescan every 30 days with push alerts

---

## App Architecture/Tech Stack

| Phase | Feature | Stack |
|-------|---------|-------|
| **1** | Upload UI + Gallery | `Flutter`, `path_provider`, `image_picker` |
| **2** | AI Risk Detection | `DistilBERT`, `tflite_flutter`,`HuggingFace Transformers` |
| **3** | Security | `flutter_secure_storage`, `encrypt` |

---

## Custom AI Module
- Fine-tuned **DistilBERT** to detect Personally Identifiable Information present in given text
- Detects terms like:
  1. Names
  2. Dates
  3. Locations
  4. Phone numbers
  5. Credit card details
  6. Date of birth and other personal details

---

## App Screens (UI Flow)

1. **Gallery Screen**
   - Grid view of all uploaded content
   - Scan option on long-press

2. **Scan Result Screen**
   - Risk tag + reason: `"Passport detected"` or `"Location inferred"`
   - Actionable suggestions

3. **Social Media Scanner**
   - Input handle + email
   - View/email detailed report
   - Enable auto-scan mode

---

## Data Privacy & Ethics

- 💡 All analysis is performed **locally**
- 🚫 No 3rd-party cloud APIs (e.g., Google Vision, Gemini)
- 🗑️ All posts, media files stored securly in local storage

---

## Colab Notebook for AI Model

📎 **[Google Colab Notebook](https://colab.research.google.com/drive/1GVKYv3HjYDs12zkIE_BMs5UVxzFXL-nx?usp=sharing)**  

---

## Getting Started

To Run the application locally-
1. Clone the repository 
    <br>
    `git clone https://github.com/Shaurya-Saini/Priv_Guard.git`<br>
    `cd Priv_Guard`
2. Create project
    <br>
    `flutter create .`
3. Run the application from `main.dart`

<br>

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
