#import <Foundation/Foundation.h>
#import <Metal/Metal.h>
#import <MetalKit/MetalKit.h>
#import <sys/sysctl.h>
#import <mach/task_info.h>
#import <mach/task.h>
#import <sys/stat.h>
#import <unistd.h>

#import "ModText.h"
#import "ModSkin.h"

#import "5Toubun/dobby.h"
#import "Esp/ImGuiDrawView.h"
#import "Esp/CaptainHook.h"
#import "5Toubun/NakanoIchika.h"
#import "5Toubun/NakanoNino.h"
#import "5Toubun/NakanoMiku.h"
#import "5Toubun/NakanoYotsuba.h"
#import "5Toubun/NakanoItsuki.h"
#import "5Toubun/Obfuscate.h"
#import "IMGUI/imgui.h"
#import "IMGUI/imgui_internal.h"
#import "IMGUI/imgui_impl_metal.h"
#import "IMGUI/zzz.h"
#import "Monostring/MonoString.h"
// #import "patchOffset.h"
#define kWidth  [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height
#define kScale [UIScreen mainScreen].scale
#define kTest   0 
#define g 0.86602540378444 
#define iPhone6s ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
#define timer(sec) dispatch_after(dispatch_time(DISPATCH_TIME_NOW, sec * NSEC_PER_SEC), dispatch_get_main_queue(), ^

@interface ImGuiDrawView () <MTKViewDelegate>
@property (nonatomic, strong) id <MTLDevice> device;
@property (nonatomic, strong) id <MTLCommandQueue> commandQueue;


@end

@implementation ImGuiDrawView


bool AimSkill; //aim elsu
int Radius = 0; //tầm aim elsu
int dame = 0; //damage kéo
int gold = 0; //gold kéo
int hp = 0; //autowin kéo
bool AutoTrung; //auto trung elsu
int skillSlot; //aim xoay
bool aimSkill1; //aim1
bool aimSkill2; //aim2
bool aimSkill3; //aim3
bool (*_IsSmartUse)(void *instance);
bool (*_get_IsUseCameraMoveWithIndicator)(void *instance);

bool IsSmartUse(void *instance){
    
    bool aim = false;
    
    if(skillSlot == 1 && aimSkill1){
        aim = true;
    }
    
    if(skillSlot == 2 && aimSkill2){
        aim = true;
    }
    
    if(skillSlot == 3 && aimSkill3){
        aim = true;
    }
    
    if(AutoTrung && aim){
        return true;
    }
    
    return _IsSmartUse(instance);
}


bool get_IsUseCameraMoveWithIndicator(void *instance){
    
    bool aim = false;
    
    if(skillSlot == 1 && aimSkill1){
        aim = true;
    }
    
    if(skillSlot == 2 && aimSkill2){
        aim = true;
    }
    
    if(skillSlot == 3 && aimSkill3){
        aim = true;
    }
    
    
    if(AutoTrung && aim){
        return true;
    }
    
    return _get_IsUseCameraMoveWithIndicator(instance);
}
void (*old_IsDistanceLowerEqualAsAttacker)(void *instance, int targetActor, int radius);
void IsDistanceLowerEqualAsAttacker(void *instance, int targetActor, int radius) {
    
    bool aim = false;
    
    if(skillSlot == 1 && aimSkill1){
        aim = true;
    }
    
    if(skillSlot == 2 && aimSkill2){
        aim = true;
    }
    
    if(skillSlot == 3 && aimSkill3){
        aim = true;
    }
    
    
    if (instance != NULL && AimSkill && aim) {
        radius = Radius * 1000;
    }
    old_IsDistanceLowerEqualAsAttacker(instance, targetActor, radius);
}
bool (*_IsUseSkillJoystick)(void *instance, int slot);
bool IsUseSkillJoystick(void *instance, int slot){
    skillSlot = slot;
    return _IsUseSkillJoystick(instance, slot);
}

//Camera Silder 3 offset
float SetFieldOfView = 2.0f;

float(*cam)(void* _this);
float _cam(void* _this){
    return SetFieldOfView;{
    return cam(_this);}
}

void (*highrate)(void *instance);
void _highrate(void *instance)
{
    highrate(instance);
}

void (*Update)(void *instance);
void _Update(void *instance)        {
    if(instance!=NULL){
        _highrate(instance);
    }
    return Update(instance);
}

//Ẩn tên tùy ý
static bool isPlayerName = false; /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

void (*old_SetPlayerName)(void *instance, MonoString *playerName, void *prefixName, bool *isGuideLevel);
void SetPlayerName(void *instance, MonoString *playerName, void *prefixName, bool *isGuideLevel) {     if (instance != NULL && isPlayerName) {
        playerName->setMonoString(ENCRYPTHEX("0"));
    }     old_SetPlayerName(instance, playerName, prefixName, isGuideLevel); }
///////////////////////////////////



//Dame kéo //222
int (*old_OnAverageHurt)(void *instance, int hp);
int OnAverageHurt(void *instance, int hp) 
{  
    if(instance != NULL && dame) 
    { 
    return dame;
    }

return old_OnAverageHurt(instance, hp);
}


//gold kéo
int (*old_GetGoldCoinInBattle)(void *instance);
int GetGoldCoinInBattle(void *instance) 
{  
       if(instance != NULL && gold) 
       { 
       return gold;
       }
return old_GetGoldCoinInBattle(instance);
}

//auto win kéo
void (*_SetHpAndEpToInitialValue)(void *player, int hpPercent, int epPercent);
void SetHpAndEpToInitialValue(void *player, int hpPercent, int epPercent) {
    if (player != NULL && hp) {
        hpPercent = hp * 1000;
    }
    _SetHpAndEpToInitialValue(player, hpPercent, epPercent);
}

//antiban hook
//anogs và unity đều 1 dạng
void (*_UnityAnti)(void *instance);
void UnityAnti(void *instance) {
    return;
}
void (*_AnogsAnti)(void *instance);
void AnogsAnti(void *instance) {
    return;
}
///////////////////////////////////////////////////////////////////////////
//setup keyboard



static bool MenDeal = true;

- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil 
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]; 
    _device = MTLCreateSystemDefaultDevice();
    _commandQueue = [_device newCommandQueue];

   
    IMGUI_CHECKVERSION();
    ImGui::CreateContext();
    ImGuiIO& io = ImGui::GetIO(); (void)io;
    
    //style menu
    ImGui::StyleColorsDark();
    //thiết lập font chữ   
    ImFont* font = io.Fonts->AddFontFromMemoryCompressedTTF((void*)zzz_compressed_data, zzz_compressed_size, 50.0f, NULL, io.Fonts->GetGlyphRangesVietnamese()); 

    ImGui_ImplMetal_Init(_device);
    return self;
}


-(void)Guest
{


timer(1.0){


UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Bạn có muốn Xóa không? / Do you want delete?" message:nil preferredStyle:UIAlertControllerStyleAlert];


UIAlertAction *huy = [UIAlertAction actionWithTitle:@"Huỷ / Cancle" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){

}];

UIAlertAction *tieptuc = [UIAlertAction actionWithTitle:@"Tiếp Tục / Resume" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){


[[NSFileManager defaultManager]
removeItemAtPath:[NSString stringWithFormat:@"%@/Documents/beetalk_session.db",NSHomeDirectory()] error:nil];
//removeItemAtPath:[NSString stringWithFormat:@"%@/Library/Caches",NSHomeDirectory()] error:nil];

exit(3);


}];

////-------/////

[tieptuc setValue:[UIColor redColor] forKey:@"titleTextColor"];
[alert addAction:huy];
[alert addAction:tieptuc];



    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:true completion:nil];

});

}







+ (void)showChange:(BOOL)open 
{
    MenDeal = open;
}

- (MTKView *)mtkView 
{
    return (MTKView *)self.view;
}

- (void)loadView {
    CGFloat w = [UIApplication sharedApplication].windows[0].rootViewController.view.frame.size.width;
    CGFloat h = [UIApplication sharedApplication].windows[0].rootViewController.view.frame.size.height;
    self.view = [[MTKView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mtkView.device = self.device;
    self.mtkView.delegate = self;
    self.mtkView.clearColor = MTLClearColorMake(0, 0, 0, 0);
    self.mtkView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    self.mtkView.clipsToBounds = YES;
    // private float GetCameraHeightRateValue(int type) { }
    // public static void ScreenEraserCameraRemove(string name) { } // * private void Update() { } * // private void LateUpdate() { }
    // private void OnCameraHeightChanged() { }
    // MSHookFunction((void*)getAbsoluteAddress("UnityFramework", 0x6132140), (void*)_cam, (void**)&cam);
    // MSHookFunction((void*)getAbsoluteAddress("UnityFramework", 0x6131148), (void*)_Update, (void**)&Update);
    // MSHookFunction((void*)getAbsoluteAddress("UnityFramework", 0x6132568), (void*)_highrate, (void**)&highrate);






    DobbyHook((void *)getRealOffset(0x6132140), (void *)_cam, (void **)&cam);
    DobbyHook((void *)getRealOffset(0x6131148), (void *)_Update, (void **)&Update);
    DobbyHook((void *)getRealOffset(0x6132568), (void *)_highrate, (void **)&highrate);
    // HOOK(ENCRYPTOFFSET("0x5982168"), IsSmartUse, _IsSmartUse);// public bool IsSmartUse() { }
    // HOOK(ENCRYPTOFFSET("0x574074C"), get_IsUseCameraMoveWithIndicator, _get_IsUseCameraMoveWithIndicator); // public bool get_IsUseCameraMoveWithIndicator() { }
    // HOOK(ENCRYPTOFFSET("0x6413310"), IsDistanceLowerEqualAsAttacker, old_IsDistanceLowerEqualAsAttacker);// public bool IsDistanceLowerEqualAsAttacker(ActorLinker targetActor, int radius) { }
    // HOOK(ENCRYPTOFFSET("0x5A45DD8"), IsUseSkillJoystick, _IsUseSkillJoystick);// public bool IsUseSkillJoystick(SkillSlotType slot) { }
    // HOOK(ENCRYPTOFFSET("0x59DA6F4"), SetPlayerName, old_SetPlayerName);// public void SetPlayerName(string playerName, string prefixName = "", bool isGuideLevel = False) { }
    // HOOK(ENCRYPTOFFSET("0x53E3100"), SetHpAndEpToInitialValue, _SetHpAndEpToInitialValue);// public void SetHpAndEpToInitialValue(int hpPercent = 10000, int epPercent = 10000) { }
    // HOOK(ENCRYPTOFFSET("0x5CBA408"), IsSkillDirControlRotate, _IsSkillDirControlRotate);// private bool IsSkillDirControlRotate(SkillSlotType skillSlotType) { }

    DobbyHook((void *)getRealOffset(0x5982168), (void *)IsSmartUse, (void **)&_IsSmartUse); 
    DobbyHook((void *)getRealOffset(0x574074C), (void *)get_IsUseCameraMoveWithIndicator, (void **)&_get_IsUseCameraMoveWithIndicator); 
    DobbyHook((void *)getRealOffset(0x6413310), (void *)IsDistanceLowerEqualAsAttacker, (void **)&old_IsDistanceLowerEqualAsAttacker); 
    DobbyHook((void *)getRealOffset(0x5A45DD8), (void *)IsUseSkillJoystick, (void **)&_IsUseSkillJoystick); 
    DobbyHook((void *)getRealOffset(0x59DA6F4), (void *)SetPlayerName, (void **)&old_SetPlayerName); 
    DobbyHook((void *)getRealOffset(0x5280DA0), (void *)OnAverageHurt, (void **)&old_OnAverageHurt); 
    //DobbyHook((void *)getRealOffset(0x53E5988), (void *)GetGoldCoinInBattle, (void **)&old_GetGoldCoinInBattle); 
    //DobbyHook((void *)getRealOffset(0x53E3100), (void *)SetHpAndEpToInitialValue, (void **)&_SetHpAndEpToInitialValue); 

    //antiband auto loading 38<= phiếu
    vm_anogs(ENCRYPTOFFSET("0x9AD1C"), strtoul(ENCRYPTHEX("0xC0035FD6"), nullptr, 0));
    vm_anogs(ENCRYPTOFFSET("0x136A24"), strtoul(ENCRYPTHEX("0xC0035FD6"), nullptr, 0));
    vm_anogs(ENCRYPTOFFSET("0x1643D0"), strtoul(ENCRYPTHEX("0xC0035FD6"), nullptr, 0));
    vm_anogs(ENCRYPTOFFSET("0x19FA50"), strtoul(ENCRYPTHEX("0xC0035FD6"), nullptr, 0));
    //antiban
    //DobbyHook((void *)getRealOffset(OFFSET), (void *)UnityAnti, (void **)&_UnityAnti);
    //DobbyHook((void *)getRealOffset(OFFSET), (void *)AnogsAnti, (void **)&_AnogsAnti);
    //ví dụ hook

} ////kết thúc 

#pragma mark - Interaction

- (void)updateIOWithTouchEvent:(UIEvent *)event {
    UITouch *anyTouch = event.allTouches.anyObject;
    CGPoint touchLocation = [anyTouch locationInView:self.view];
    ImGuiIO &io = ImGui::GetIO();
    io.MousePos = ImVec2(touchLocation.x, touchLocation.y);

    BOOL hasActiveTouch = NO;
    for (UITouch *touch in event.allTouches) {
        if (touch.phase != UITouchPhaseEnded && touch.phase != UITouchPhaseCancelled) {
            hasActiveTouch = YES;
            break;
        }
    }
    io.MouseDown[0] = hasActiveTouch;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self updateIOWithTouchEvent:event];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self updateIOWithTouchEvent:event];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self updateIOWithTouchEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self updateIOWithTouchEvent:event];
}


#pragma mark - MTKViewDelegate

bool isJailbroken() {
    struct stat s;
    return (stat("/bin/bash", &s) == 0);
}

- (void)mtkView:(nonnull MTKView *)view drawableSizeWillChange:(CGSize)size {
    // Handle the drawable size change if needed
}

- (void)drawInMTKView:(MTKView*)view {
    ImGuiIO& io = ImGui::GetIO();
    io.DisplaySize.x = view.bounds.size.width;
    io.DisplaySize.y = view.bounds.size.height;


//120 hoặc 60 là thông số fps của menu
    CGFloat framebufferScale = view.window.screen.scale ?: UIScreen.mainScreen.scale;
    io.DisplayFramebufferScale = ImVec2(framebufferScale, framebufferScale);
    io.DeltaTime = 1.0f / float(view.preferredFramesPerSecond ?: 120);
    
    id<MTLCommandBuffer> commandBuffer = [self.commandQueue commandBuffer];

    static bool _isShowMenu = true;
//khai báo biến
static bool hmap = false;
static bool hlsd = false;
static bool fps = false;
static bool btro = false;
static bool hrank = false;
static bool c3n = false;
static bool cc = false;
static bool nocd = false;
static bool uid = false;
static bool uidrom = false;
static bool mana = false;
static bool battu = false;








    if (MenDeal == true) 
    {
        [self.view setUserInteractionEnabled:YES];
    } 
    else if (MenDeal == false) 
    {
        [self.view setUserInteractionEnabled:NO];
    }

    MTLRenderPassDescriptor* renderPassDescriptor = view.currentRenderPassDescriptor;
    if (renderPassDescriptor != nil) {
        id <MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];
        [renderEncoder pushDebugGroup:@"ImGui Jane"];

        ImGui_ImplMetal_NewFrame(renderPassDescriptor);
        ImGui::NewFrame();

        ImFont* font = ImGui::GetFont();
        font->Scale = 15.f / font->FontSize;

        CGFloat x = (([UIApplication sharedApplication].windows[0].rootViewController.view.frame.size.width) - 360) / 2;
        CGFloat y = (([UIApplication sharedApplication].windows[0].rootViewController.view.frame.size.height) - 300) / 2;

        //thiết lập kích cỡ menu chiều ngang 380, chiều cao 310
        ImGui::SetNextWindowPos(ImVec2(x, y), ImGuiCond_FirstUseEver);
        ImGui::SetNextWindowSize(ImVec2(310, 320), ImGuiCond_FirstUseEver);






        if (MenDeal == true) 
        { //bắt đầu biến MenDeal

        







            std::string namedv = [[UIDevice currentDevice] name].UTF8String;
            NSDate *now = [NSDate date];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"EEEE dd/MM/yyyy"];
            NSString *dateString = [dateFormatter stringFromDate:now];

            UIDevice *device = [UIDevice currentDevice];
            device.batteryMonitoringEnabled = YES;

            float batteryLevel = device.batteryLevel * 100;
            NSString *chargingStatus = @"";
            if (device.batteryState == UIDeviceBatteryStateCharging) {
                chargingStatus = @"- Connected";
            } else if (device.batteryState == UIDeviceBatteryStateFull) {
                chargingStatus = @"- Full";
            } else {
                chargingStatus = @"- Disconnected";
            }

            int numCores;
            size_t len = sizeof(numCores);
            sysctlbyname("hw.ncpu", &numCores, &len, NULL, 0);

            kern_return_t kr;
            task_info_data_t tinfo;
            mach_msg_type_number_t task_info_count = TASK_INFO_MAX;
          
            kr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)tinfo, &task_info_count);
            if (kr != KERN_SUCCESS) {
                return;
            }

            task_basic_info_t basic_info;
            thread_array_t thread_list;
            mach_msg_type_number_t thread_count;
          
            thread_info_data_t thinfo;
            mach_msg_type_number_t thread_info_count;

            basic_info = (task_basic_info_t)tinfo;
          
            // Calculate RAM usage
            natural_t used_ram = (basic_info->resident_size) / 1024 / 1024;
            // Calculate available RAM
            natural_t free_ram = ([NSProcessInfo processInfo].physicalMemory) / 1024 / 1024 - used_ram;
            char used_ram_str[100];
            char free_ram_str[100];
          
            ImVec4 used_color = ImVec4(0.5f, 0, 0.5f, 1);
            ImVec4 ram_color = ImVec4(1, 1, 0, 1);

            long num_cpus = sysconf(_SC_NPROCESSORS_ONLN);
            long page_size = sysconf(_SC_PAGESIZE);
            long num_pages = sysconf(_SC_PHYS_PAGES);
            long ram_total = num_pages * page_size;

        









               

                //bắt đầu viết menu
                ImGui::Begin("AOV [x64] Mobile", &MenDeal, ImGuiWindowFlags_NoResize);
   

                ImGui::BeginTabBar("Bar");
                if (ImGui::BeginTabItem("  Home")) 
                {
                ImGui::TextColored(ImColor(250, 250, 250), "Trạng thái:");
                ImGui::SameLine();
                 ImGui::TextColored(ImColor(9, 255, 0), "Login success!");

ImGui::TextColored(ImVec4(1.0f, 1.0f, 1.0f, 1.0f), "Ios: ");
                ImGui::SameLine();
                if (isJailbroken()) 
                {
                    ImGui::TextColored(ImVec4(1.0f, 0.0f, 0.0f, 1.0f), "JailBroken !");
                }
                else 
                {
                    ImGui::TextColored(ImVec4(0.0f, 1.0f, 0.0f, 1.0f), "Non Jailbreak !");       
                }
                ImGui::Separator();
                // Thời gian
                ImGui::TextColored(ImColor(255, 255, 255), "Today: ");
                ImGui::SameLine();
                ImGui::TextColored(ImColor(0, 255, 255), "%s", [dateString UTF8String]);

                ImColor white(255, 255, 255);
                ImGui::TextColored(white, "Battery: ");

                ImColor yellow(255, 255, 0);
                ImGui::SameLine();
                ImGui::TextColored(yellow, " %.0f%%", batteryLevel);

                ImColor green(0, 255, 0);
                ImColor red(255, 0, 0);
                ImColor statusTextColor;
                if (device.batteryState == UIDeviceBatteryStateCharging) {
                    statusTextColor = green;
                } else {
                    statusTextColor = red;
                }
                ImGui::SameLine();
                ImGui::TextColored(statusTextColor, "%s", [chargingStatus UTF8String]);

                ImGui::TextColored(white, "CPU: ");
                ImGui::SameLine();
                ImGui::TextColored(ImColor(0, 255, 0), " %ld Bytes", ram_total);
                ImGui::SameLine();
                ImGui::TextColored(ImColor(102, 255, 102), "Core: %ld", num_cpus);

                ImVec4 used_text_color(1, 0, 1, 1);
                ImVec4 used_info_color(1, 1, 0, 1);

                ImGui::TextColored(white, "RAM: ");
                ImGui::SameLine();
                int used_ram_len = snprintf(used_ram_str, sizeof(used_ram_str), "%s: %d MB", "Use", used_ram);

                if (used_ram_len > 0) {
                    ImGui::TextColored(used_text_color, "%s", "Used: ");
                    ImGui::SameLine();
                    ImGui::TextColored(used_info_color, "%d MB", used_ram);
                }
                ImGui::SameLine(); ImGui::TextColored(white, " / ");
                ImGui::SameLine();

                sprintf(free_ram_str, " %d MB", free_ram);
                if (strlen(free_ram_str) > 0) {
                    ImGui::TextColored(ImVec4(0, 1, 0, 1), "Remaining: ");
                    ImGui::SameLine();
                    ImGui::TextColored(ImVec4(1, 0, 0, 1), "%s", free_ram_str);
                }

                ImGui::Separator();
                ImGui::Separator();
                NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
                const char *bundleIdentifierUTF8 = [bundleIdentifier UTF8String];
                if (bundleIdentifierUTF8 != NULL && strlen(bundleIdentifierUTF8) > 0) {
                    ImGui::TextColored(white, "Bundle: ");
                    ImGui::SameLine();
                    ImGui::TextColored(white, "%s", bundleIdentifierUTF8);
                }
                ImGui::TextColored(red, "2024 @ Cbeios");

                ImGui::TableNextColumn();
                ImGui::TextColored(green, "(%.3f ms/frame (%.1f FPS))", 500.0f / ImGui::GetIO().Framerate, ImGui::GetIO().Framerate);

                ImGui::TableNextColumn();

                ImGui::TextColored(yellow, "Bypass Server Game Success");
ImGui::TableNextColumn();
        

                 
       ImGui::EndTabItem();
                }








                if (ImGui::BeginTabItem(" Mod")) {
                ImGui::Separator();
                if (ImGui::BeginTable("Table", 2)) {
                    ImGui::SetWindowFontScale(1.1f);
                    ImGui::TableNextColumn(); 


                    if (hmap){
                        vm_unity(ENCRYPTOFFSET("0x5331A08"), strtoul(ENCRYPTHEX("0x360080D2"), nullptr, 0));
                    } else {
                        // Original patch here if needed
                    }
                    ImGui::Checkbox("Check Map", &hmap);        ImGui::TableNextColumn();

                    if (hlsd){
                        vm_unity(ENCRYPTOFFSET("0x5C4C590"), strtoul(ENCRYPTHEX("0x200080D2C0035FD6"), nullptr, 0));
                    } else {
                        // Original patch here if needed
                    }
                    ImGui::Checkbox("Hiện Lịch Sử Đấu", &hlsd);     ImGui::TableNextColumn(); 

                    if (fps){
                        vm_unity(ENCRYPTOFFSET("0x5E47048"), strtoul(ENCRYPTHEX("0xC0035FD6"), nullptr, 0));
                        vm_unity(ENCRYPTOFFSET("0x5E46F50"), strtoul(ENCRYPTHEX("0xC0035FD6"), nullptr, 0));
                    } else {
                        // Original patch here if needed
                    }
                    ImGui::Checkbox("Fix FPS", &fps); 
                    ImGui::TableNextColumn();

                    if (btro){
                        vm_unity(ENCRYPTOFFSET("0x5FC0FF8"), strtoul(ENCRYPTHEX("0x1F2003D5"), nullptr, 0));
                    } else {
                        // Original patch here if needed
                    }
                    ImGui::Checkbox("Hiện Bổ Trợ", &btro);      ImGui::TableNextColumn();


                    if (hrank){
                        vm_unity(ENCRYPTOFFSET("0x5EEC550"), strtoul(ENCRYPTHEX("0x1F2003D5"), nullptr, 0));
                    } else {
                        // Original patch here if needed
                    }
                    ImGui::Checkbox("Hiện Rank", &hrank);       ImGui::TableNextColumn();
            

                    if (isPlayerName){

                    } else {
                        // Original patch here if needed
                    }
                    ImGui::Checkbox("Ẩn Tên", &isPlayerName);      ImGui::TableNextColumn();

                    if (c3n){
                        vm_unity(ENCRYPTOFFSET("0x5E3AD60"), strtoul(ENCRYPTHEX("0x20008052C0035FD6"), nullptr, 0));
                    } else {
                        // Original patch here if needed
                    }
                    ImGui::Checkbox("Cam 3 Nấc", &c3n); 
                    ImGui::TableNextColumn();

                    
                    if (cc){

                        vm_unity(ENCRYPTOFFSET("0x5E21A50"), strtoul(ENCRYPTHEX("0x370080D2"), nullptr, 0));
                    } else {
                        // Original patch here if needed
                    }
                    ImGui::Checkbox("Hiện Tên Cấm Chọn", &cc);     ImGui::TableNextColumn();




                   ImGui::EndTable();
                    }

           




ImGui::Text("Mod For Elsu Aim Bot");
ImGui::TableNextColumn();
                //aimskill
                ImGui::Checkbox(" Aim ", &AimSkill);
                ImGui::SameLine();
                ImGui::Checkbox("Auto Trúng", &AutoTrung); 


                ImGui::Checkbox(" 01",&aimSkill1);
                ImGui::SameLine();


                ImGui::Checkbox("02",&aimSkill2);
                ImGui::SameLine();


                ImGui::Checkbox("03",&aimSkill3);
                ImGui::TextColored(ImColor(18, 255, 0), "Distance Elsu");
                ImGui::SameLine();


                ImGui::SliderInt( "##2", &Radius, 3, 25, "%dmét" );

                ImGui::EndTabItem();
                }







                if (ImGui::BeginTabItem(" Playerid")) {

        ImGui::Separator();        
        if (ImGui::Button("Đăng xuất nhanh acc bị band"))
        {
            [self Guest];
        }
                          
     
        ImGui::Spacing(); 
                if (ImGui::Button("Set language", ImVec2(-1, 40))) {
                UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:NSSENCRYPT("Liên Quân Mobile | AOV VN") message:NSSENCRYPT("Thay thế các văn bản bạn muốn vào các lệnh.") preferredStyle:UIAlertControllerStyleAlert];

                    [alertCtrl addAction:[UIAlertAction actionWithTitle:@"Hạ" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                        [ModText replaceTextInFileWithAlert:@"Documents/Resources/1.55.1/Languages/VN_Garena_VN/languageMap_Newbie.txt"
                          originalText:@"Kill_Info_Type_Kill = "
                        viewController:self];
                    }]];


                    [alertCtrl addAction:[UIAlertAction actionWithTitle:@"Chiến công đầu" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {

                        [ModText replaceTextInFileWithAlert:@"Documents/Resources/1.55.1/Languages/VN_Garena_VN/languageMap_Newbie.txt"
                          originalText:@"Kill_Info_Type_First_Kill = "
                        viewController:self];
                    }]];

                    [alertCtrl addAction:[UIAlertAction actionWithTitle:@"Cân 2" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {

                        [ModText replaceTextInFileWithAlert:@"Documents/Resources/1.55.1/Languages/VN_Garena_VN/languageMap_Newbie.txt"
                          originalText:@"Kill_Info_Type_DoubleKill = "
                        viewController:self];
                    }]];

                    [alertCtrl addAction:[UIAlertAction actionWithTitle:@"Cân 3" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {

                        [ModText replaceTextInFileWithAlert:@"Documents/Resources/1.55.1/Languages/VN_Garena_VN/languageMap_Newbie.txt"
                          originalText:@"Kill_Info_Type_TripleKill = "
                        viewController:self];
                    }]];

                    [alertCtrl addAction:[UIAlertAction actionWithTitle:@"Cân 4" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {

                        [ModText replaceTextInFileWithAlert:@"Documents/Resources/1.55.1/Languages/VN_Garena_VN/languageMap_Newbie.txt"
                          originalText:@"Kill_Info_Type_QuataryKill = "
                        viewController:self];
                    }]];

                    [alertCtrl addAction:[UIAlertAction actionWithTitle:@"Cân 5" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {

                        [ModText replaceTextInFileWithAlert:@"Documents/Resources/1.55.1/Languages/VN_Garena_VN/languageMap_Newbie.txt"
                          originalText:@"Kill_Info_Type_PentaKill = "
                        viewController:self];
                    }]];

                    [alertCtrl addAction:[UIAlertAction actionWithTitle:@"Đóng" style:UIAlertActionStyleDefault handler:nil]];
                    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertCtrl animated:YES completion:nil];
                }

                ImGui::TableNextColumn();
            if (ImGui::Button("Giải mã language", ImVec2(-1, 40))) 
            {
                [ModText backup];
            }

        ImGui::Spacing();

//modskin
if (ImGui::Button("Mod Full Skin", ImVec2(-1, 40)))
        {
            [ModSkin ActiveModFull];
        }
        ImGui::TableNextColumn();

if (ImGui::Button("Mod Skin Link", ImVec2(-1, 40)))
        {
            [ModSkin ActiveMod];
        }

        ImGui::TableNextColumn();
        if (ImGui::Button("Mod Skin Bằng Tệp Zip", ImVec2(-1, 40)))
        {
            [ModSkin ActiveModFile];
        }

        ImGui::TableNextColumn();
        if (ImGui::Button("Sao lưu/Xóa Mod Skin", ImVec2(-1, 40)))
        {
            [ModSkin Backup];
        }






        ImGui::Spacing(); 
      ImGui::EndTabItem();
                 }






                 if (ImGui::BeginTabItem(" Pro")) {
                ImGui::Separator();






                if (uid){

                        vm_unity(ENCRYPTOFFSET("0x5BF5B7C"), strtoul(ENCRYPTHEX("0xC0035FD6"), nullptr, 0));
                    } else {
                        // Original patch here if needed
                    }
                    ImGui::Checkbox("Ẩn UID", &uid);
                ImGui::TableNextColumn();






                if (uidrom){

                        vm_unity(ENCRYPTOFFSET("0x5E91D8C"), strtoul(ENCRYPTHEX("0xC0035FD6"), nullptr, 0));
                    } else {
                        // Original patch here if needed
                    }
                    ImGui::Checkbox("Ẩn UID Phòng", &uidrom);
ImGui::TableNextColumn();




if (mana){

vm_unity(ENCRYPTOFFSET("0x539D1D0"), strtoul(ENCRYPTHEX("0x000080D2C0035FD6"), nullptr, 0));                    

               } else { 

     
                        
                    }
                    ImGui::Checkbox("Không Mất Mana", &mana); 
ImGui::TableNextColumn();





if (nocd){

                        vm_unity(ENCRYPTOFFSET("0x53B4FF4"), strtoul(ENCRYPTHEX("0xC0035FD6"), nullptr, 0));
                    } else {
                        // Original patch here if needed
                    }
                    ImGui::Checkbox("No CoolDown", &nocd); 
ImGui::TableNextColumn();





if (battu){

                        vm_unity(ENCRYPTOFFSET("0x4FD1044"), strtoul(ENCRYPTHEX("0x00E0AFD2C0035FD6"), nullptr, 0));
                    } else {
                        
                    }
                    ImGui::Checkbox("Bất Tử", &battu);
ImGui::TableNextColumn();

ImGui::TextColored(ImColor(255, 0, 0), "SliderCam");
                ImGui::SameLine();
//cam kéo
static float fovValue = 2.0f;
                    ImGui::SliderFloat(" ", &fovValue, 2.0f, 13.0f, "Camera Kéo");
                    SetFieldOfView = fovValue;

ImGui::TableNextColumn();



ImGui::TextColored(ImColor(255, 0, 0), "Up Dame");
                ImGui::SameLine(); 
ImGui::SliderInt( "##3", &dame, 0, 9500, "%d" ); 
ImGui::TableNextColumn();




ImGui::TextColored(ImColor(255, 255, 0), "Up Golds");
         ImGui::SameLine(); 
ImGui::SliderInt( "##4", &gold, 80, 467999, "%d" ); 
ImGui::TableNextColumn();




ImGui::TextColored(ImColor(0, 255, 0), "UpAuWin");
                ImGui::SameLine(); 
ImGui::SliderInt( "##6", &hp, 369, 12698, "%d" ); 
ImGui::TableNextColumn();


      ImGui::EndTabItem();
            }

       ImGui::End();

}  //end MenDeal
     
        ImDrawList* draw_list = ImGui::GetBackgroundDrawList();
        ImGuiStyle& style = ImGui::GetStyle();
        // Thiết lập giao diện người dùng trong suốt
style.Colors[ImGuiCol_WindowBg].w = 8.7f;  // Đặt mức độ đục của nền cửa sổ thành 0 (suốt)

        style.WindowRounding = 10.0f;
        style.WindowTitleAlign = ImVec2(0.5f, 0.5f);
        style.ChildRounding = 6.0f;
        style.PopupRounding = 6.0f;
        style.FrameRounding = 6.0f;
        style.FrameBorderSize = 1.0f;
        style.GrabRounding = 12.0f;
        style.TabRounding = 7.0f;
        style.ButtonTextAlign = ImVec2(0.5f, 0.5f);
        style.Alpha = 9.9f;

        ImGui::Render();
        ImGui_ImplMetal_RenderDrawData(ImGui::GetDrawData(), commandBuffer, renderEncoder);
        [renderEncoder popDebugGroup];
        [renderEncoder endEncoding];
        [commandBuffer presentDrawable:view.currentDrawable];
    }
    [commandBuffer commit];

}
@end
