# 🔧 UnityGaussianSplatting 의존성 문제 해결 가이드

## ⚠️ 문제 요약

현재 발생하는 컴파일 에러:
```
error CS0246: The type or namespace name 'GaussianSplatRenderer' could not be found
error CS0246: The type or namespace name 'GaussianSplatAsset' could not be found
```

**원인**: UnityGaussianSplatting 플러그인이 **잘못된 위치(Assets/Plugins)**에 설치되었습니다.

**올바른 위치**: `Packages/` 폴더 (UPM 패키지용)

---

## 🛠️ 해결 방법 (3가지 옵션)

### ✅ 옵션 1: Package Manager 사용 (가장 쉬움 - 권장!)

1. **Unity Editor 열기**

2. **잘못 설치된 플러그인 삭제**:
   - Project 창에서 `Assets/Plugins/UnityGaussianSplatting` 폴더 찾기
   - 우클릭 → Delete
   - 확인 다이얼로그에서 "Delete" 클릭

3. **Package Manager로 재설치**:
   ```
   Window → Package Manager
   좌측 상단 "+" 버튼 클릭
   "Add package from git URL" 선택
   ```

4. **올바른 URL 입력**:
   ```
   https://github.com/aras-p/UnityGaussianSplatting.git?path=/package
   ```

   ⚠️ **중요**: `?path=/package` 를 반드시 포함하세요!

5. **Add 클릭**

6. **Unity Editor 재시작**

7. **설치 확인**:
   - `Window → Package Manager` 열기
   - 좌측 드롭다운에서 "In Project" 선택
   - "Gaussian Splatting" 패키지가 보이면 성공!

---

### ✅ 옵션 2: Git으로 Packages 폴더에 수동 설치

1. **Unity Editor 닫기**

2. **잘못 설치된 플러그인 삭제**:
   - 파일 탐색기 열기
   - `C:\sanhak\unity_gaussian_splatting_viewer\Assets\Plugins\UnityGaussianSplatting` 폴더 삭제

3. **Git Bash 열기** (또는 PowerShell)

4. **Packages 폴더로 이동**:
   ```bash
   cd "C:/sanhak/unity_gaussian_splatting_viewer/Packages"
   ```

5. **올바른 위치에 클론**:
   ```bash
   git clone https://github.com/aras-p/UnityGaussianSplatting.git
   ```

6. **Unity Editor 재시작**

7. **설치 확인** (옵션 1의 7번 참조)

---

### ✅ 옵션 3: Package Manifest 직접 수정 (고급)

1. **Unity Editor 닫기**

2. **잘못 설치된 플러그인 삭제** (옵션 2의 2번 참조)

3. **manifest.json 파일 열기**:
   ```
   C:\sanhak\unity_gaussian_splatting_viewer\Packages\manifest.json
   ```

4. **dependencies 섹션에 추가**:
   ```json
   {
     "dependencies": {
       "com.aras-p.gaussian-splatting": "https://github.com/aras-p/UnityGaussianSplatting.git?path=/package",
       "com.unity.burst": "1.8.18",
       "com.unity.collections": "2.1.4",
       "com.unity.mathematics": "1.2.6",
       ...
     }
   }
   ```

5. **Unity Editor 재시작**

6. **설치 확인** (옵션 1의 7번 참조)

---

## ✅ 성공 확인 방법

1. **Package Manager 확인**:
   - `Window → Package Manager`
   - "In Project" 선택
   - "Gaussian Splatting" 패키지가 목록에 있어야 함

2. **Console 확인**:
   - `Window → Console`
   - 컴파일 에러가 모두 사라져야 함

3. **스크립트 확인**:
   - `Assets/Scripts/SplatLoader.cs` 파일 열기
   - `GaussianSplatRenderer`에 빨간 밑줄이 없어야 함

---

## 📋 설치 후 다음 단계

컴파일 에러가 해결되면 다음 작업을 진행하세요:

### 1. Unity 씬 구성

1. **새 씬 생성**:
   - `Assets → Create → Scene`
   - 이름: `GaussianSplattingViewer`

2. **Main Camera 설정**:
   - Hierarchy에서 `Main Camera` 선택
   - Inspector → Add Component → `OrbitCamera`

3. **SplatLoader GameObject 생성**:
   - Hierarchy 우클릭 → Create Empty
   - 이름: `SplatLoader`
   - Add Component → `SplatLoader`
   - Add Component → `GaussianSplatRenderer`
   - SplatLoader 컴포넌트의 Splat Renderer에 자기 자신 드래그

4. **UnityMessageManager GameObject 생성**:
   - Hierarchy 우클릭 → Create Empty
   - 이름: `UnityMessageManager`
   - Add Component → `UnityMessageManager`

5. **씬 저장**:
   - `File → Save` (Ctrl+S)

### 2. Build Settings 구성

1. **씬 추가**:
   - `File → Build Settings`
   - `Add Open Scenes` 클릭

2. **Android 플랫폼 전환**:
   - Platform: Android 선택
   - Switch Platform 클릭

3. **Player Settings**:
   - Package Name: `com.ongi.gaussiansplatting`
   - Minimum API Level: Android 7.0 (API 24)
   - Scripting Backend: IL2CPP
   - Target Architectures: ARM64 체크

### 3. Export (Build 아님!)

1. **Export Project 체크** ⭐ 중요!
   - `File → Build Settings`
   - Export Project 체크박스 활성화

2. **Export 버튼 클릭**

3. **저장 위치 선택**:
   ```
   Flutter 프로젝트 경로/android/unityLibrary
   ```

---

## 🔍 왜 Packages 폴더인가요?

### Assets/Plugins (❌ 잘못됨)
- 일반 Unity 에셋용 폴더
- Assembly Definition이 제한적으로 작동
- 패키지 버전 관리 불가
- 의존성 자동 해결 안 됨

### Packages/ (✅ 올바름)
- UPM(Unity Package Manager) 전용 폴더
- Assembly Definition 완벽 지원
- 패키지 버전 관리 가능
- 의존성 자동 해결
- Unity 권장 방식

**UnityGaussianSplatting은 UPM 패키지**이므로 반드시 Packages/ 폴더에 있어야 합니다!

---

## 📞 추가 도움

문제가 계속되면 다음을 확인하세요:

1. Unity 버전: 2021.3 LTS 이상 (현재: 2022.3.61f1 - OK!)
2. Git 설치 여부
3. 인터넷 연결 상태
4. Unity Editor Console에서 다른 에러 확인

자세한 가이드: `UNITY_SETUP_DETAILED.md` 참조

---

## 🎯 핵심 요약

1. ❌ **Assets/Plugins**에 설치 → 컴파일 에러
2. ✅ **Packages/**에 설치 → 정상 작동
3. ⭐ URL에 `?path=/package` 필수!

간단하죠? 😊
