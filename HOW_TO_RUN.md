# 🚀 실행 가이드 - 가우시안 스플래팅 뷰어

## 📱 지금 바로 테스트하기 (Unity 없이!)

현재 **목업(Mock) 버전**으로 설정되어 있어서 Unity 없이도 UI 흐름을 바로 테스트할 수 있습니다!

---

## ⚡ 빠른 시작 (5분)

### 1단계: 패키지 설치

```bash
cd /home/user/ongi/ongi_flutter
flutter pub get
```

**예상 출력:**
```
Running "flutter pub get" in ongi_flutter...
Resolving dependencies...
+ flutter_unity_widget 2022.2.0
+ http 1.1.0
+ permission_handler 11.0.1
Changed 3 dependencies!
```

### 2단계: 앱 실행

#### Android 에뮬레이터에서 실행

```bash
# 에뮬레이터 실행 확인
flutter devices

# 앱 실행
flutter run
```

#### 실제 디바이스에서 실행

```bash
# USB 디버깅 연결 확인
flutter devices

# 앱 실행
flutter run -d <device-id>
```

### 3단계: 테스트

1. 앱 실행 후 **로그인**
2. **홈 화면** 이동
3. 우측 상단의 **파란색 "가우시안 스플래팅" 버튼** 클릭
4. 다운로드 진행률 확인 (시뮬레이션)
5. 목업 뷰어 화면 확인

---

## 🎯 현재 구현 상태

### ✅ 완료된 기능 (지금 테스트 가능)

- [x] 홈 화면 "가우시안 스플래팅" 버튼
- [x] 다운로드 진행률 UI
- [x] 뷰어 화면 레이아웃
- [x] 로딩 상태 표시
- [x] 에러 처리 UI
- [x] Provider 상태 관리

### ⏳ 대기 중 (Unity 설치 후 가능)

- [ ] 실제 .ply 파일 로드
- [ ] 3D 렌더링
- [ ] 터치 조작 (회전, 줌)
- [ ] Unity 통신

---

## 📂 파일 구조

```
ongi_flutter/
├── lib/
│   ├── providers/
│   │   └── gaussian_splatting_provider.dart      ✅ 작동
│   ├── services/
│   │   └── gaussian_splatting_service.dart       ✅ 작동
│   ├── screens/
│   │   ├── main/
│   │   │   └── home_screen.dart                  ✅ 작동 (목업 사용 중)
│   │   └── gaussian_splatting/
│   │       ├── gaussian_splatting_viewer_screen.dart        ⏳ Unity 필요
│   │       └── gaussian_splatting_viewer_screen_mock.dart   ✅ 작동 (현재 사용)
│   └── main.dart                                  ✅ 작동
```

---

## 🔄 목업 → 실제 Unity 버전 전환 방법

나중에 Unity 준비가 되면 다음과 같이 변경하면 됩니다:

### `ongi_flutter/lib/screens/main/home_screen.dart` 수정

**변경 전 (현재 - 목업 버전):**
```dart
// import '../gaussian_splatting/gaussian_splatting_viewer_screen.dart';  // Unity 버전 (나중에 사용)
import '../gaussian_splatting/gaussian_splatting_viewer_screen_mock.dart';  // 목업 버전 (현재 사용)

// ...

Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => GaussianSplattingViewerScreenMock(  // 목업
      // ...
    ),
  ),
);
```

**변경 후 (Unity 버전):**
```dart
import '../gaussian_splatting/gaussian_splatting_viewer_screen.dart';  // Unity 버전
// import '../gaussian_splatting/gaussian_splatting_viewer_screen_mock.dart';  // 목업 버전

// ...

Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => GaussianSplattingViewerScreen(  // Unity
      // ...
    ),
  ),
);
```

**단 2줄만 수정하면 됩니다!**

---

## 🧪 테스트 시나리오

### 시나리오 1: 정상 흐름

1. 홈 화면에서 버튼 클릭
2. 다운로드 진행률 표시 (0% → 100%)
3. 로딩 화면 표시 ("Unity 엔진 초기화 중...")
4. 목업 뷰어 화면 표시
5. 우측 상단 리셋 버튼 클릭 → 스낵바 표시
6. 뒤로가기 → 홈 화면 복귀

### 시나리오 2: 에러 케이스

현재 목업에서는 에러가 발생하지 않지만, 실제 버전에서는:
- 네트워크 오류 시 → 재시도 버튼 표시
- 파일 없음 → 에러 메시지 표시
- Unity 로드 실패 → 에러 화면 표시

---

## 🐛 문제 해결

### 문제 1: flutter pub get 실패

```bash
# 캐시 정리
flutter pub cache repair
cd ongi_flutter
flutter clean
flutter pub get
```

### 문제 2: 버튼이 보이지 않음

**원인**: 3D 모델 데이터가 없음

**해결**:
- 백엔드 API가 3D 모델 데이터를 반환하는지 확인
- `model_url` 필드가 있는지 확인

### 문제 3: 앱 빌드 실패

```bash
# Android
cd ongi_flutter/android
./gradlew clean

# Flutter
cd ..
flutter clean
flutter pub get
flutter run
```

---

## 📋 체크리스트

실행 전에 확인하세요:

- [ ] Flutter SDK 설치됨 (`flutter --version`)
- [ ] Android Studio / Xcode 설치됨
- [ ] 에뮬레이터 또는 실제 기기 연결됨 (`flutter devices`)
- [ ] 프로젝트 디렉토리에 있음 (`pwd` → `.../ongi/ongi_flutter`)
- [ ] `flutter pub get` 실행됨

---

## 🎬 실행 스크린샷 예상

### 1. 홈 화면
```
┌─────────────────────────┐
│  [기와 이미지]            │
│              [가우시안 스플래팅] ← 버튼
├─────────────────────────┤
│   ← [3D 모델 이름]  →   │
│      1 / 3              │
│                         │
│   [3D 모델 뷰어]        │
│                         │
│   설명: ...             │
└─────────────────────────┘
```

### 2. 다운로드 중
```
┌─────────────────────────┐
│  [←] 가우시안 스플래팅   [↻] │
├─────────────────────────┤
│                         │
│      [●●●●○○○○]        │
│   모델 다운로드 중...    │
│         45%             │
│                         │
└─────────────────────────┘
```

### 3. 목업 뷰어
```
┌─────────────────────────┐
│  [←] 백제 금동대향로     [↻] │
├─────────────────────────┤
│                         │
│         [🎨]            │
│  가우시안 스플래팅 뷰어   │
│      (목업)             │
│                         │
│  Model ID: artifact_123 │
│  실제 Unity 뷰어는      │
│  여기에 표시됩니다       │
│                         │
│  ┌─────────────────┐   │
│  │ 💡 조작 방법     │   │
│  │ 1-finger: 회전   │   │
│  │ 2-finger: 줌     │   │
│  └─────────────────┘   │
└─────────────────────────┘
│  설명: 백제시대의...     │
└─────────────────────────┘
```

---

## 🚀 다음 단계

### 옵션 A: Unity 통합 (완전한 구현)

1. Unity Hub 설치
2. Unity Editor 2021.3 LTS+ 설치
3. `UNITY_INTEGRATION_GUIDE.md` 따라 진행
4. Unity Export
5. home_screen.dart에서 목업 → 실제 버전 전환

**예상 시간**: 2~3시간

### 옵션 B: 목업으로 계속 (UI 완성도 향상)

1. 목업 화면에 더 많은 인터랙션 추가
2. 애니메이션 효과 추가
3. 설명 섹션 개선

**예상 시간**: 1시간

### 옵션 C: 현재 상태 유지 (나중에 진행)

- 코드는 모두 준비됨
- Unity 개발자 합류 시 진행
- 현재는 다른 기능 개발

---

## 💡 팁

1. **목업으로 먼저 UX 검증**: Unity 없이도 사용자 흐름 확인 가능
2. **백엔드 API 먼저 준비**: `gaussian_model_url` 필드 추가
3. **테스트 .ply 파일 준비**: 무료 샘플 파일로 테스트
4. **점진적 통합**: 작은 단위로 테스트하며 진행

---

## 📞 도움이 필요하면

**오류 발생 시 확인할 것:**
1. `flutter doctor` 실행
2. 로그 확인: `flutter run --verbose`
3. Android Studio Logcat 확인

**질문 있으면 물어보세요!** 🙋‍♂️
