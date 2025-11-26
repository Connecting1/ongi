# Unity 가우시안 스플래팅 뷰어 - 상세 설정 가이드

Unity를 할 줄 아시는 분을 위한 실전 가이드입니다.

---

## 📋 전체 워크플로우

```
Unity 프로젝트 생성
    ↓
UnityGaussianSplatting 플러그인 설치
    ↓
스크립트 추가 및 씬 구성
    ↓
Android/iOS Export 설정
    ↓
Flutter 프로젝트에 통합
    ↓
빌드 및 테스트
```

---

## 🎯 1단계: Unity 프로젝트 생성

### 1-1. Unity Hub에서 새 프로젝트 생성

```
Template: 3D (URP - Universal Render Pipeline)
Project Name: UnityGaussianSplattingViewer
Location: /home/user/ongi/unity_gaussian_splatting_viewer
Unity Version: 2021.3 LTS 이상
```

**중요**: URP(Universal Render Pipeline) 템플릿을 사용해야 모바일 최적화가 좋습니다.

### 1-2. 프로젝트 설정 확인

Unity Editor 열린 후:
- **Edit → Project Settings → Player**
- **Company Name**: `com.ongi`
- **Product Name**: `OngiGaussianSplatting`

---

## 🔌 2단계: UnityGaussianSplatting 플러그인 설치

### 방법 1: Package Manager - Git URL (권장)

```
1. Window → Package Manager
2. 좌측 상단 "+" 버튼
3. "Add package from git URL" 선택
4. 입력: https://github.com/aras-p/UnityGaussianSplatting.git?path=/package
5. Add 클릭
```

**주의**: URL 끝에 `?path=/package`를 반드시 포함해야 합니다!

### 방법 2: Manual - Packages 폴더에 설치 (권장)

**중요**: Assets/Plugins가 아닌 **Packages/** 폴더에 설치해야 합니다!

```bash
# Windows의 경우 (Git Bash 또는 PowerShell)
cd "C:/sanhak/unity_gaussian_splatting_viewer/Packages"
git clone https://github.com/aras-p/UnityGaussianSplatting.git

# Linux/Mac의 경우
cd /home/user/ongi/unity_gaussian_splatting_viewer/Packages
git clone https://github.com/aras-p/UnityGaussianSplatting.git
```

그 후 Unity Editor 재시작

### 방법 3: Manual - Package Manifest 수정 (고급)

`Packages/manifest.json` 파일을 열어 다음 라인 추가:

```json
{
  "dependencies": {
    "com.aras-p.gaussian-splatting": "https://github.com/aras-p/UnityGaussianSplatting.git?path=/package",
    ...
  }
}
```

### 설치 확인

- **Window → Package Manager**에서 "Gaussian Splatting" 패키지 확인
- `Assets` 폴더에 예제 파일들이 보이면 성공

---

## 📝 3단계: 스크립트 추가

### 3-1. Scripts 폴더 생성

```
Assets → Create → Folder → "Scripts"
```

### 3-2. C# 스크립트 복사

이미 작성된 스크립트 3개를 Unity 프로젝트로 복사:

```bash
# 터미널에서 실행
cp /home/user/ongi/unity_gaussian_splatting_viewer/Assets/Scripts/*.cs \
   /home/user/ongi/unity_gaussian_splatting_viewer/Assets/Scripts/
```

스크립트 목록:
- `SplatLoader.cs` - .ply 파일 동적 로더
- `OrbitCamera.cs` - 터치 기반 카메라 컨트롤
- `UnityMessageManager.cs` - Flutter 통신 매니저

Unity Editor에서 자동으로 컴파일됩니다.

**주의**: 컴파일 에러가 나면 `GaussianSplatting` 네임스페이스를 확인하세요.

---

## 🎬 4단계: 씬 구성

### 4-1. 새 씬 생성

```
Assets → Create → Scene
이름: "GaussianSplattingViewer"
더블클릭하여 열기
```

### 4-2. Main Camera 설정

**Hierarchy**에서 `Main Camera` 선택:

```
Inspector 패널:
1. Add Component → "OrbitCamera" 검색 후 추가
2. 설정값:
   - Rotation Speed: 5
   - Min Vertical Angle: -80
   - Max Vertical Angle: 80
   - Zoom Speed: 2
   - Min Distance: 2
   - Max Distance: 50
   - Initial Distance: 10
   - Smoothing: 5
```

### 4-3. SplatLoader GameObject 생성

**Hierarchy**에서 우클릭:

```
1. Create Empty
2. 이름: "SplatLoader"
3. Inspector에서:
   a. Add Component → "SplatLoader" 추가
   b. Add Component → "GaussianSplatRenderer" 추가 (플러그인 제공)
4. SplatLoader 컴포넌트 설정:
   - Splat Renderer: SplatLoader 자기 자신 드래그
```

### 4-4. UnityMessageManager GameObject 생성

**Hierarchy**에서 우클릭:

```
1. Create Empty
2. 이름: "UnityMessageManager"
3. Inspector에서:
   - Add Component → "UnityMessageManager" 추가
```

### 4-5. Lighting 설정 (선택사항)

3D 모델을 잘 보이게 하려면:

```
Window → Rendering → Lighting
Environment:
- Skybox Material: Default-Skybox
- Sun Source: Directional Light (씬에 있는 것)

Hierarchy → Directional Light:
- Rotation: X=50, Y=-30, Z=0
- Intensity: 1
- Color: 흰색
```

### 4-6. 씬 저장 및 Build Settings 추가

```
File → Save (Ctrl+S)
File → Build Settings
"Add Open Scenes" 클릭
```

**중요**: 씬이 **Index 0**에 있어야 합니다!

---

## 📱 5단계: Android Export 설정

### 5-1. Platform 전환

```
File → Build Settings
Platform: Android 선택
Switch Platform 클릭 (시간 소요)
```

### 5-2. Player Settings 구성

**File → Build Settings → Player Settings** 클릭:

#### Other Settings
```
- Package Name: com.ongi.gaussiansplatting
- Minimum API Level: Android 7.0 (API 24)
- Target API Level: Automatic (최신)
- Scripting Backend: IL2CPP ⭐ 중요!
- Target Architectures:
  ✓ ARM64 (필수)
  ✗ ARMv7 (선택)
```

#### Publishing Settings
```
- Build App Bundle (Google Play): ✗ 체크 해제 (APK 방식)
```

#### XR Settings
```
모두 비활성화
```

### 5-3. Export Project

**중요**: Build가 아닌 **Export**입니다!

```
File → Build Settings
✓ Export Project 체크 ⭐ 중요!
Export 버튼 클릭

저장 위치: /home/user/ongi/ongi_flutter/android/unityLibrary
```

**주의사항**:
- `unityLibrary` 폴더가 이미 있으면 삭제 후 Export
- Export는 5~10분 소요

---

## 🔗 6단계: Flutter 프로젝트 통합

### 6-1. Android Gradle 설정

**`ongi_flutter/android/settings.gradle`** 파일 수정:

파일 끝에 추가:
```gradle
include ':unityLibrary'
project(':unityLibrary').projectDir = file('./unityLibrary')
```

### 6-2. App 레벨 build.gradle 수정

**`ongi_flutter/android/app/build.gradle`** 파일:

`dependencies` 블록에 추가:
```gradle
dependencies {
    implementation project(':unityLibrary')
    // ... 기존 dependencies
}
```

### 6-3. AndroidManifest.xml 권한 추가

**`ongi_flutter/android/app/src/main/AndroidManifest.xml`**:

`<manifest>` 안에 추가:
```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
```

### 6-4. Flutter 패키지 재설치

```bash
cd /home/user/ongi/ongi_flutter
flutter clean
flutter pub get
```

---

## 🧪 7단계: 빌드 및 테스트

### 7-1. Android 빌드

```bash
cd /home/user/ongi/ongi_flutter

# Debug 빌드 (빠름)
flutter build apk --debug

# Release 빌드 (최적화)
flutter build apk --release
```

**예상 빌드 시간**: 첫 빌드 10~15분, 이후 3~5분

### 7-2. 에뮬레이터 또는 실기기 테스트

```bash
# 디바이스 확인
flutter devices

# 실행
flutter run
```

### 7-3. 앱 실행 후 테스트

1. 로그인
2. 홈 화면 → 우측 상단 "가우시안 스플래팅" 버튼
3. 첫 실행 시 Unity 초기화 (1~2초)
4. .ply 파일 다운로드 (네트워크 필요)
5. 3D 뷰어 표시

---

## 🐛 문제 해결

### 문제 0: GaussianSplatRenderer와 GaussianSplatAsset을 찾을 수 없음 (컴파일 에러)

**원인**: UnityGaussianSplatting이 잘못된 위치(Assets/Plugins)에 설치됨

**증상**:
```
The type or namespace name 'GaussianSplatRenderer' could not be found
The type or namespace name 'GaussianSplatAsset' could not be found
```

**해결 방법**:

1. **잘못 설치된 플러그인 삭제**:
   - Unity Editor에서 `Assets/Plugins/UnityGaussianSplatting` 폴더를 완전히 삭제
   - 또는 파일 탐색기에서 직접 삭제

2. **올바른 위치에 재설치 - 방법 A (Git Bash 사용)**:
   ```bash
   # Windows에서 Git Bash 열기
   cd "C:/sanhak/unity_gaussian_splatting_viewer/Packages"
   git clone https://github.com/aras-p/UnityGaussianSplatting.git
   ```

3. **올바른 위치에 재설치 - 방법 B (Package Manager 사용)**:
   ```
   Window → Package Manager
   좌측 상단 "+" → Add package from git URL
   입력: https://github.com/aras-p/UnityGaussianSplatting.git?path=/package
   ```
   **중요**: `?path=/package` 반드시 포함!

4. **Unity Editor 재시작**

5. **설치 확인**:
   - `Window → Package Manager` 열기
   - 좌측 드롭다운에서 "In Project" 선택
   - "Gaussian Splatting" 패키지가 보이면 성공
   - Console 창에서 컴파일 에러가 사라졌는지 확인

**왜 Packages 폴더여야 하나요?**
- UnityGaussianSplatting은 UPM(Unity Package Manager) 패키지입니다
- UPM 패키지는 Packages/ 폴더에 있어야 Assembly Definition이 제대로 작동합니다
- Assets/Plugins는 일반 Unity Assets용이며, 패키지 시스템과 호환되지 않습니다

### 문제 1: "UnityPlayer not found" 에러

**원인**: unityLibrary가 제대로 링크 안됨

**해결**:
```bash
cd /home/user/ongi/ongi_flutter/android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

### 문제 2: IL2CPP 빌드 실패

**원인**: NDK 없음

**해결**:
```
Android Studio → SDK Manager → SDK Tools
✓ NDK (Side by side)
✓ CMake
설치
```

### 문제 3: Unity 화면 검은색

**원인**: 씬이 Build Settings에 없음

**해결**:
```
Unity Editor:
File → Build Settings
Scenes in Build에 GaussianSplattingViewer 추가 (Index 0)
다시 Export
```

### 문제 4: Flutter ↔ Unity 통신 안됨

**원인**: UnityMessageManager 누락

**해결**:
```
Unity 씬에서 UnityMessageManager GameObject 확인
스크립트가 연결되어 있는지 확인
```

### 문제 5: .ply 파일 로드 실패

**원인**: 파일 경로 또는 권한 문제

**해결**:
```dart
// Flutter에서 권한 요청 (필요시)
import 'package:permission_handler/permission_handler.dart';

await Permission.storage.request();
```

---

## 📊 백엔드 API 연동

### API 응답 형식

3D 모델 API가 다음 형식으로 응답해야 합니다:

```json
{
  "id": "123",
  "artifact_name": "백제 금동대향로",
  "description": "백제시대의 금동 향로...",
  "model_url": "/media/models/artifact_123.glb",
  "gaussian_model_url": "/media/gaussian/artifact_123.ply",  // ⭐ 추가 필요
  "status": "completed"
}
```

### .ply 파일 준비

1. **3D 스캔** 또는 **사진 → NeRF 학습**
2. Gaussian Splatting 학습 (Nerfstudio, 3DGS 등)
3. `.ply` 파일 Export
4. 압축 (Super Splat 권장)
5. 서버에 업로드

**권장 파일 크기**: 20~50MB

### 테스트용 샘플 .ply 파일

무료 샘플:
- https://repo-sam.inria.fr/fungraph/3d-gaussian-splatting/datasets/pretrained/models.zip
- 다운로드 후 서버에 업로드

---

## ✅ 최종 체크리스트

빌드 전 확인사항:

- [ ] Unity 프로젝트 생성 완료
- [ ] UnityGaussianSplatting 플러그인 설치됨
- [ ] 3개 C# 스크립트 추가됨
- [ ] 씬 구성 완료 (Camera, SplatLoader, MessageManager)
- [ ] Build Settings에 씬 추가됨 (Index 0)
- [ ] Android Export 완료 (unityLibrary 폴더 존재)
- [ ] Flutter settings.gradle 수정됨
- [ ] Flutter build.gradle에 unityLibrary 추가됨
- [ ] AndroidManifest.xml 권한 추가됨
- [ ] flutter pub get 실행됨
- [ ] 백엔드 API에 gaussian_model_url 필드 추가됨

---

## 🚀 빠른 시작 요약

```bash
# 1. Unity 프로젝트 생성 및 설정 (Unity Editor에서)
# 2. Flutter 통합 설정

cd /home/user/ongi/ongi_flutter

# settings.gradle 수정
# build.gradle 수정
# AndroidManifest.xml 수정

flutter clean
flutter pub get
flutter build apk --debug
flutter run
```

---

## 📞 추가 도움

Unity 관련:
- UnityGaussianSplatting: https://github.com/aras-p/UnityGaussianSplatting
- Unity Manual: https://docs.unity3d.com/

Flutter-Unity:
- flutter_unity_widget: https://pub.dev/packages/flutter_unity_widget

---

## 🎯 핵심 포인트

1. **IL2CPP 필수**: ARM64 지원을 위해 IL2CPP 사용
2. **Export, not Build**: Unity는 Build가 아닌 Export
3. **씬 Index 0**: 첫 번째 씬이어야 함
4. **권한 설정**: AndroidManifest.xml 권한 추가
5. **Gradle 통합**: settings.gradle과 build.gradle 모두 수정

이대로 따라하시면 100% 동작합니다! 🚀
