<GameFile>
  <PropertyGroup Name="SpreadMyAgentView" Type="Layer" ID="bc5f4e3e-26ca-4fb8-92a0-f5cf23840260" Version="3.10.0.0" />
  <Content ctype="GameProjectContent">
    <Content>
      <Animation Duration="95" Speed="1.0000">
        <Timeline ActionTag="-1785410848" Property="Position">
          <PointFrame FrameIndex="70" X="403.6800" Y="323.5200">
            <EasingData Type="0" />
          </PointFrame>
          <PointFrame FrameIndex="80" X="403.6800" Y="323.5200">
            <EasingData Type="0" />
          </PointFrame>
          <PointFrame FrameIndex="85" X="403.6800" Y="323.5200">
            <EasingData Type="0" />
          </PointFrame>
          <PointFrame FrameIndex="95" X="403.6800" Y="323.5200">
            <EasingData Type="0" />
          </PointFrame>
        </Timeline>
        <Timeline ActionTag="-1785410848" Property="Scale">
          <ScaleFrame FrameIndex="70" X="1.0000" Y="0.0001">
            <EasingData Type="0" />
          </ScaleFrame>
          <ScaleFrame FrameIndex="80" X="1.0000" Y="1.0000">
            <EasingData Type="0" />
          </ScaleFrame>
          <ScaleFrame FrameIndex="85" X="1.0000" Y="1.0000">
            <EasingData Type="0" />
          </ScaleFrame>
          <ScaleFrame FrameIndex="95" X="1.0000" Y="1.0000">
            <EasingData Type="0" />
          </ScaleFrame>
        </Timeline>
        <Timeline ActionTag="-1785410848" Property="RotationSkew">
          <ScaleFrame FrameIndex="70" X="0.0000" Y="0.0000">
            <EasingData Type="0" />
          </ScaleFrame>
          <ScaleFrame FrameIndex="80" X="0.0000" Y="0.0000">
            <EasingData Type="0" />
          </ScaleFrame>
          <ScaleFrame FrameIndex="85" X="0.0000" Y="0.0000">
            <EasingData Type="0" />
          </ScaleFrame>
          <ScaleFrame FrameIndex="95" X="0.0000" Y="0.0000">
            <EasingData Type="0" />
          </ScaleFrame>
        </Timeline>
        <Timeline ActionTag="-1785410848" Property="AnchorPoint">
          <ScaleFrame FrameIndex="80" X="0.5000" Y="1.0000">
            <EasingData Type="0" />
          </ScaleFrame>
          <ScaleFrame FrameIndex="85" X="0.5000" Y="1.0000">
            <EasingData Type="0" />
          </ScaleFrame>
          <ScaleFrame FrameIndex="95" X="0.5000" Y="1.0000">
            <EasingData Type="0" />
          </ScaleFrame>
        </Timeline>
        <Timeline ActionTag="-1785410848" Property="VisibleForFrame">
          <BoolFrame FrameIndex="70" Tween="False" Value="True" />
          <BoolFrame FrameIndex="95" Tween="False" Value="False" />
        </Timeline>
      </Animation>
      <AnimationList>
        <AnimationInfo Name="AnimationSlecet" StartIndex="70" EndIndex="80">
          <RenderColor A="255" R="128" G="128" B="128" />
        </AnimationInfo>
        <AnimationInfo Name="AnimationUnSlecet" StartIndex="85" EndIndex="95">
          <RenderColor A="255" R="154" G="205" B="50" />
        </AnimationInfo>
      </AnimationList>
      <ObjectData Name="UiEntity34055563" ctype="GameLayerObjectData">
        <Size X="1334.0000" Y="750.0000" />
        <Children>
          <AbstractNodeData Name="SpreadTutorial" ActionTag="-1" Tag="2507" IconVisible="False" ClipAble="False" BackColorAlpha="0" ComboBoxIndex="1" ColorAngle="0.0000" Scale9Width="1" Scale9Height="1" ctype="PanelObjectData">
            <Size X="1334.0000" Y="750.0000" />
            <Children>
              <AbstractNodeData Name="Panel_node_tutorial" ActionTag="17565875" Tag="2510" IconVisible="False" LeftMargin="404.0000" RightMargin="184.0000" TopMargin="139.0000" BottomMargin="86.0000" TouchEnable="True" ClipAble="False" BackColorAlpha="100" ColorAngle="0.0000" Scale9Width="1" Scale9Height="1" ctype="PanelObjectData">
                <Size X="746.0000" Y="525.0000" />
                <Children>
                  <AbstractNodeData Name="Button_nextpage" ActionTag="440461887" Tag="951" IconVisible="False" LeftMargin="292.0562" RightMargin="381.9438" TopMargin="450.4976" BottomMargin="48.5024" TouchEnable="True" FontSize="26" ButtonText="下一页" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="4" BottomEage="4" Scale9OriginX="15" Scale9OriginY="4" Scale9Width="48" Scale9Height="18" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                    <Size X="72.0000" Y="26.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="328.0562" Y="61.5024" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.4398" Y="0.1171" />
                    <PreSize X="0.0965" Y="0.0495" />
                    <TextColor A="255" R="108" G="39" B="39" />
                    <DisabledFileData Type="Default" Path="Default/Button_Disable.png" Plist="" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="110" G="110" B="110" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Button_lastpage" ActionTag="-429515650" Tag="952" IconVisible="False" LeftMargin="417.5000" RightMargin="253.5000" TopMargin="450.4258" BottomMargin="45.5742" TouchEnable="True" FontSize="26" ButtonText="上一页" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="4" BottomEage="4" Scale9OriginX="15" Scale9OriginY="4" Scale9Width="48" Scale9Height="18" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                    <Size X="75.0000" Y="29.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="455.0000" Y="60.0742" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.6099" Y="0.1144" />
                    <PreSize X="0.1005" Y="0.0552" />
                    <TextColor A="255" R="108" G="39" B="39" />
                    <DisabledFileData Type="Default" Path="Default/Button_Disable.png" Plist="" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="110" G="110" B="110" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Button_addAgent" ActionTag="1641287896" Tag="103" IconVisible="False" LeftMargin="656.8911" RightMargin="-64.8911" TopMargin="436.4604" BottomMargin="38.5396" TouchEnable="True" FontSize="24" ButtonText="添加代理" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="124" Scale9Height="28" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                    <Size X="154.0000" Y="50.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="733.8911" Y="63.5396" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.9838" Y="0.1210" />
                    <PreSize X="0.2064" Y="0.0952" />
                    <TextColor A="255" R="255" G="255" B="255" />
                    <DisabledFileData Type="Default" Path="Default/Button_Disable.png" Plist="" />
                    <PressedFileData Type="PlistSubImage" Path="hall/plist/an2.png" Plist="hall/plist/promotor.plist" />
                    <NormalFileData Type="PlistSubImage" Path="hall/plist/an1.png" Plist="hall/plist/promotor.plist" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="110" G="110" B="110" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="bg_imagetext" ActionTag="2106146731" Tag="922" IconVisible="True" LeftMargin="-7.1199" RightMargin="753.1199" TopMargin="530.3406" BottomMargin="-5.3406" ctype="SingleNodeObjectData">
                    <Size X="0.0000" Y="0.0000" />
                    <Children>
                      <AbstractNodeData Name="Label_1" ActionTag="1891355140" Tag="932" IconVisible="False" LeftMargin="-11.0776" RightMargin="-108.9224" TopMargin="-550.9925" BottomMargin="526.9925" FontSize="24" LabelText="下级代理id" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="120.0000" Y="24.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="48.9224" Y="538.9925" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="108" G="59" B="27" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <OutlineColor A="255" R="0" G="0" B="0" />
                        <ShadowColor A="255" R="0" G="0" B="0" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Label_1_3" ActionTag="-1368353918" Tag="933" IconVisible="False" LeftMargin="137.3792" RightMargin="-233.3792" TopMargin="-550.0612" BottomMargin="526.0612" FontSize="24" LabelText="代理昵称" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="96.0000" Y="24.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="185.3792" Y="538.0612" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="108" G="59" B="27" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <OutlineColor A="255" R="0" G="0" B="0" />
                        <ShadowColor A="255" R="0" G="0" B="0" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Label_1_2" ActionTag="832942865" Tag="934" IconVisible="False" LeftMargin="275.4922" RightMargin="-371.4922" TopMargin="-550.5576" BottomMargin="526.5576" FontSize="24" LabelText="代理级别" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="96.0000" Y="24.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="323.4922" Y="538.5576" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="108" G="59" B="27" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <OutlineColor A="255" R="0" G="0" B="0" />
                        <ShadowColor A="255" R="0" G="0" B="0" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Label_1_1" ActionTag="922961748" Tag="935" IconVisible="False" LeftMargin="420.0065" RightMargin="-516.0065" TopMargin="-551.6877" BottomMargin="527.6877" FontSize="24" LabelText="团队人数" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="96.0000" Y="24.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="420.0065" Y="539.6877" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="108" G="59" B="27" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <OutlineColor A="255" R="0" G="0" B="0" />
                        <ShadowColor A="255" R="0" G="0" B="0" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Image_2_0_0_0" ActionTag="-676038533" Tag="928" IconVisible="False" LeftMargin="-18.9322" RightMargin="-120.0678" TopMargin="-569.7999" BottomMargin="518.7999" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="63" Scale9Height="59" ctype="ImageViewObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="50.5678" Y="544.2999" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="hall/plist/bj1.png" Plist="hall/plist/promotor.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Image_2_0_0_0_0" ActionTag="-935797128" Tag="943" IconVisible="False" LeftMargin="120.0802" RightMargin="-259.0802" TopMargin="-569.7999" BottomMargin="518.7999" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="63" Scale9Height="59" ctype="ImageViewObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="189.5802" Y="544.2999" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="hall/plist/bj1.png" Plist="hall/plist/promotor.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Image_2_0_0_0_1" ActionTag="1930134358" Tag="944" IconVisible="False" LeftMargin="259.0927" RightMargin="-398.0927" TopMargin="-569.7999" BottomMargin="518.7999" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="63" Scale9Height="59" ctype="ImageViewObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="328.5927" Y="544.2999" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="hall/plist/bj1.png" Plist="hall/plist/promotor.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Image_2_0_0_0_2" ActionTag="-1801310292" Tag="945" IconVisible="False" LeftMargin="398.1051" RightMargin="-537.1051" TopMargin="-569.7999" BottomMargin="518.7999" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="63" Scale9Height="59" ctype="ImageViewObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="467.6051" Y="544.2999" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="hall/plist/bj1.png" Plist="hall/plist/promotor.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Image_2_0_0_0_3" ActionTag="1853259203" Tag="946" IconVisible="False" LeftMargin="537.1174" RightMargin="-676.1174" TopMargin="-569.7999" BottomMargin="518.7999" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="63" Scale9Height="59" ctype="ImageViewObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="606.6174" Y="544.2999" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="hall/plist/bj1.png" Plist="hall/plist/promotor.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Image_2_0_0_0_3_0" ActionTag="285436802" Tag="947" IconVisible="False" LeftMargin="676.1299" RightMargin="-815.1299" TopMargin="-569.7999" BottomMargin="518.7999" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="63" Scale9Height="59" ctype="ImageViewObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="745.6299" Y="544.2999" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="hall/plist/bj1.png" Plist="hall/plist/promotor.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Label_1_1_0" ActionTag="1271102938" Tag="949" IconVisible="False" LeftMargin="548.3842" RightMargin="-668.3842" TopMargin="-549.1960" BottomMargin="529.1960" FontSize="20" LabelText="本周团队贡献" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="120.0000" Y="20.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="608.3842" Y="539.1960" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="108" G="59" B="27" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <OutlineColor A="255" R="0" G="0" B="0" />
                        <ShadowColor A="255" R="0" G="0" B="0" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Label_1_1_1" ActionTag="-1692655116" Tag="950" IconVisible="False" LeftMargin="685.2133" RightMargin="-805.2133" TopMargin="-546.8828" BottomMargin="526.8828" FontSize="20" LabelText="代理级别调整" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="120.0000" Y="20.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="685.2133" Y="536.8828" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="108" G="59" B="27" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <OutlineColor A="255" R="0" G="0" B="0" />
                        <ShadowColor A="255" R="0" G="0" B="0" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Label_1_1_1_0" ActionTag="-1987008208" Tag="953" IconVisible="False" LeftMargin="389.6059" RightMargin="-417.6059" TopMargin="-81.0816" BottomMargin="53.0816" FontSize="28" LabelText="—" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="28.0000" Y="28.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="389.6059" Y="67.0816" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="108" G="59" B="27" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <OutlineColor A="255" R="0" G="0" B="0" />
                        <ShadowColor A="255" R="0" G="0" B="0" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint />
                    <Position X="-7.1199" Y="-5.3406" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="-0.0095" Y="-0.0102" />
                    <PreSize X="0.0000" Y="0.0000" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="node_item_1" ActionTag="-1188332168" Tag="948" IconVisible="True" LeftMargin="-28.7700" RightMargin="774.7700" TopMargin="39.8792" BottomMargin="485.1208" ctype="SingleNodeObjectData">
                    <Size X="0.0000" Y="0.0000" />
                    <Children>
                      <AbstractNodeData Name="Image_1" ActionTag="531158611" Tag="923" IconVisible="False" LeftMargin="3.3060" RightMargin="-142.3060" TopMargin="-28.2433" BottomMargin="-22.7567" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="63" Scale9Height="59" ctype="ImageViewObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="72.8060" Y="2.7433" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="hall/plist/bj0.png" Plist="hall/plist/promotor.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Image_2" ActionTag="1192811549" Tag="954" IconVisible="False" LeftMargin="142.4714" RightMargin="-281.4714" TopMargin="-28.2433" BottomMargin="-22.7567" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="63" Scale9Height="59" ctype="ImageViewObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="211.9714" Y="2.7433" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="hall/plist/bj0.png" Plist="hall/plist/promotor.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Image_3" ActionTag="-405935835" Tag="955" IconVisible="False" LeftMargin="281.4407" RightMargin="-420.4407" TopMargin="-28.2433" BottomMargin="-22.7567" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="63" Scale9Height="59" ctype="ImageViewObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="350.9407" Y="2.7433" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="hall/plist/bj0.png" Plist="hall/plist/promotor.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Image_4" ActionTag="-37140808" Tag="956" IconVisible="False" LeftMargin="421.0115" RightMargin="-560.0115" TopMargin="-28.2433" BottomMargin="-22.7567" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="63" Scale9Height="59" ctype="ImageViewObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="490.5115" Y="2.7433" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="hall/plist/bj0.png" Plist="hall/plist/promotor.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Image_5" ActionTag="809929913" Tag="957" IconVisible="False" LeftMargin="559.5823" RightMargin="-698.5823" TopMargin="-28.2433" BottomMargin="-22.7567" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="63" Scale9Height="59" ctype="ImageViewObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="629.0823" Y="2.7433" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="hall/plist/bj0.png" Plist="hall/plist/promotor.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Image_6" ActionTag="-1384542305" Tag="958" IconVisible="False" LeftMargin="699.1517" RightMargin="-838.1517" TopMargin="-28.2433" BottomMargin="-22.7567" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="63" Scale9Height="59" ctype="ImageViewObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="768.6517" Y="2.7433" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="hall/plist/bj0.png" Plist="hall/plist/promotor.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_1" ActionTag="19272729" Tag="959" IconVisible="False" LeftMargin="74.6805" RightMargin="-74.6805" TopMargin="-2.2941" BottomMargin="2.2941" FontSize="20" LabelText="" HorizontalAlignmentType="HT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="0.0000" Y="0.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="74.6805" Y="2.2941" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="108" G="59" B="27" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_2" ActionTag="-1313140459" Tag="960" IconVisible="False" LeftMargin="213.9604" RightMargin="-213.9604" TopMargin="-2.2941" BottomMargin="2.2941" FontSize="20" LabelText="" HorizontalAlignmentType="HT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="0.0000" Y="0.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="213.9604" Y="2.2941" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="108" G="59" B="27" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_3" ActionTag="-1082313309" Tag="961" IconVisible="False" LeftMargin="353.2416" RightMargin="-353.2416" TopMargin="-2.2941" BottomMargin="2.2941" FontSize="20" LabelText="" HorizontalAlignmentType="HT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="0.0000" Y="0.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="353.2416" Y="2.2941" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="108" G="59" B="27" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_4" ActionTag="-1823689193" Tag="962" IconVisible="False" LeftMargin="492.5211" RightMargin="-492.5211" TopMargin="-2.2941" BottomMargin="2.2941" FontSize="20" LabelText="" HorizontalAlignmentType="HT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="0.0000" Y="0.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="492.5211" Y="2.2941" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="108" G="59" B="27" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_5" ActionTag="1254922764" Tag="963" IconVisible="False" LeftMargin="631.8009" RightMargin="-631.8009" TopMargin="-2.2941" BottomMargin="2.2941" FontSize="20" LabelText="" HorizontalAlignmentType="HT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="0.0000" Y="0.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="631.8009" Y="2.2941" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="108" G="59" B="27" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_6" ActionTag="1967007649" Tag="964" IconVisible="False" LeftMargin="771.0809" RightMargin="-771.0809" TopMargin="-2.2941" BottomMargin="2.2941" FontSize="20" LabelText="" HorizontalAlignmentType="HT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="0.0000" Y="0.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="771.0809" Y="2.2941" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="108" G="59" B="27" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Btn_change" ActionTag="-86753548" Tag="463" IconVisible="False" LeftMargin="692.0000" RightMargin="-846.0000" TopMargin="-29.0000" BottomMargin="-21.0000" TouchEnable="True" FontSize="28" ButtonText="调整" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="124" Scale9Height="28" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                        <Size X="154.0000" Y="50.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="769.0000" Y="4.0000" />
                        <Scale ScaleX="0.6200" ScaleY="0.6200" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <TextColor A="255" R="255" G="255" B="255" />
                        <DisabledFileData Type="Default" Path="Default/Button_Disable.png" Plist="" />
                        <PressedFileData Type="PlistSubImage" Path="hall/plist/an2.png" Plist="hall/plist/promotor.plist" />
                        <NormalFileData Type="PlistSubImage" Path="hall/plist/an1.png" Plist="hall/plist/promotor.plist" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint />
                    <Position X="-28.7700" Y="485.1208" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="-0.0386" Y="0.9240" />
                    <PreSize X="0.0000" Y="0.0000" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="node_item_2" ActionTag="782218284" Tag="291" IconVisible="True" LeftMargin="-28.7700" RightMargin="774.7700" TopMargin="89.5042" BottomMargin="435.4958" ctype="SingleNodeObjectData">
                    <Size X="0.0000" Y="0.0000" />
                    <Children>
                      <AbstractNodeData Name="Image_1" ActionTag="440466427" Tag="292" IconVisible="False" LeftMargin="3.3060" RightMargin="-142.3060" TopMargin="-28.2433" BottomMargin="-22.7567" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="63" Scale9Height="59" ctype="ImageViewObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="72.8060" Y="2.7433" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="hall/plist/bj0.png" Plist="hall/plist/promotor.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Image_2" ActionTag="-186486786" Tag="293" IconVisible="False" LeftMargin="142.4714" RightMargin="-281.4714" TopMargin="-28.2433" BottomMargin="-22.7567" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="63" Scale9Height="59" ctype="ImageViewObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="211.9714" Y="2.7433" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="hall/plist/bj0.png" Plist="hall/plist/promotor.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Image_3" ActionTag="-573374335" Tag="294" IconVisible="False" LeftMargin="281.4407" RightMargin="-420.4407" TopMargin="-28.2433" BottomMargin="-22.7567" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="63" Scale9Height="59" ctype="ImageViewObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="350.9407" Y="2.7433" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="hall/plist/bj0.png" Plist="hall/plist/promotor.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Image_4" ActionTag="-408484611" Tag="295" IconVisible="False" LeftMargin="421.0115" RightMargin="-560.0115" TopMargin="-28.2433" BottomMargin="-22.7567" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="63" Scale9Height="59" ctype="ImageViewObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="490.5115" Y="2.7433" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="hall/plist/bj0.png" Plist="hall/plist/promotor.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Image_5" ActionTag="1971407003" Tag="296" IconVisible="False" LeftMargin="559.5823" RightMargin="-698.5823" TopMargin="-28.2433" BottomMargin="-22.7567" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="63" Scale9Height="59" ctype="ImageViewObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="629.0823" Y="2.7433" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="hall/plist/bj0.png" Plist="hall/plist/promotor.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Image_6" ActionTag="1401612534" Tag="297" IconVisible="False" LeftMargin="699.1517" RightMargin="-838.1517" TopMargin="-28.2433" BottomMargin="-22.7567" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="63" Scale9Height="59" ctype="ImageViewObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="768.6517" Y="2.7433" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="hall/plist/bj0.png" Plist="hall/plist/promotor.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_1" ActionTag="138206447" Tag="298" IconVisible="False" LeftMargin="74.6805" RightMargin="-74.6805" TopMargin="-2.2941" BottomMargin="2.2941" FontSize="20" LabelText="" HorizontalAlignmentType="HT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="0.0000" Y="0.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="74.6805" Y="2.2941" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="108" G="59" B="27" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_2" ActionTag="1973506350" Tag="299" IconVisible="False" LeftMargin="213.9604" RightMargin="-213.9604" TopMargin="-2.2941" BottomMargin="2.2941" FontSize="20" LabelText="" HorizontalAlignmentType="HT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="0.0000" Y="0.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="213.9604" Y="2.2941" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="108" G="59" B="27" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_3" ActionTag="252722175" Tag="300" IconVisible="False" LeftMargin="353.2416" RightMargin="-353.2416" TopMargin="-2.2941" BottomMargin="2.2941" FontSize="20" LabelText="" HorizontalAlignmentType="HT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="0.0000" Y="0.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="353.2416" Y="2.2941" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="108" G="59" B="27" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_4" ActionTag="-1489817107" Tag="301" IconVisible="False" LeftMargin="492.5211" RightMargin="-492.5211" TopMargin="-2.2941" BottomMargin="2.2941" FontSize="20" LabelText="" HorizontalAlignmentType="HT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="0.0000" Y="0.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="492.5211" Y="2.2941" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="108" G="59" B="27" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_5" ActionTag="594153349" Tag="302" IconVisible="False" LeftMargin="631.8009" RightMargin="-631.8009" TopMargin="-2.2941" BottomMargin="2.2941" FontSize="20" LabelText="" HorizontalAlignmentType="HT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="0.0000" Y="0.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="631.8009" Y="2.2941" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="108" G="59" B="27" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_6" ActionTag="-1079668149" Tag="303" IconVisible="False" LeftMargin="771.0809" RightMargin="-771.0809" TopMargin="-2.2941" BottomMargin="2.2941" FontSize="20" LabelText="" HorizontalAlignmentType="HT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="0.0000" Y="0.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="771.0809" Y="2.2941" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="108" G="59" B="27" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Btn_change" ActionTag="2063965740" Tag="470" IconVisible="False" LeftMargin="692.0000" RightMargin="-846.0000" TopMargin="-29.0000" BottomMargin="-21.0000" TouchEnable="True" FontSize="28" ButtonText="调整" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="124" Scale9Height="28" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                        <Size X="154.0000" Y="50.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="769.0000" Y="4.0000" />
                        <Scale ScaleX="0.6200" ScaleY="0.6200" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <TextColor A="255" R="255" G="255" B="255" />
                        <DisabledFileData Type="Default" Path="Default/Button_Disable.png" Plist="" />
                        <PressedFileData Type="PlistSubImage" Path="hall/plist/an2.png" Plist="hall/plist/promotor.plist" />
                        <NormalFileData Type="PlistSubImage" Path="hall/plist/an1.png" Plist="hall/plist/promotor.plist" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint />
                    <Position X="-28.7700" Y="435.4958" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="-0.0386" Y="0.8295" />
                    <PreSize X="0.0000" Y="0.0000" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="node_item_3" ActionTag="842006866" Tag="304" IconVisible="True" LeftMargin="-28.7700" RightMargin="774.7700" TopMargin="139.1294" BottomMargin="385.8706" ctype="SingleNodeObjectData">
                    <Size X="0.0000" Y="0.0000" />
                    <Children>
                      <AbstractNodeData Name="Image_1" ActionTag="-1700989668" Tag="305" IconVisible="False" LeftMargin="3.3060" RightMargin="-142.3060" TopMargin="-28.2433" BottomMargin="-22.7567" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="63" Scale9Height="59" ctype="ImageViewObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="72.8060" Y="2.7433" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="hall/plist/bj0.png" Plist="hall/plist/promotor.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Image_2" ActionTag="1326816560" Tag="306" IconVisible="False" LeftMargin="142.4714" RightMargin="-281.4714" TopMargin="-28.2433" BottomMargin="-22.7567" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="63" Scale9Height="59" ctype="ImageViewObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="211.9714" Y="2.7433" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="hall/plist/bj0.png" Plist="hall/plist/promotor.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Image_3" ActionTag="-1986863635" Tag="307" IconVisible="False" LeftMargin="281.4407" RightMargin="-420.4407" TopMargin="-28.2433" BottomMargin="-22.7567" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="63" Scale9Height="59" ctype="ImageViewObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="350.9407" Y="2.7433" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="hall/plist/bj0.png" Plist="hall/plist/promotor.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Image_4" ActionTag="1652556611" Tag="308" IconVisible="False" LeftMargin="421.0115" RightMargin="-560.0115" TopMargin="-28.2433" BottomMargin="-22.7567" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="63" Scale9Height="59" ctype="ImageViewObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="490.5115" Y="2.7433" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="hall/plist/bj0.png" Plist="hall/plist/promotor.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Image_5" ActionTag="2128630408" Tag="309" IconVisible="False" LeftMargin="559.5823" RightMargin="-698.5823" TopMargin="-28.2433" BottomMargin="-22.7567" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="63" Scale9Height="59" ctype="ImageViewObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="629.0823" Y="2.7433" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="hall/plist/bj0.png" Plist="hall/plist/promotor.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Image_6" ActionTag="1495966028" Tag="310" IconVisible="False" LeftMargin="699.1517" RightMargin="-838.1517" TopMargin="-28.2433" BottomMargin="-22.7567" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="63" Scale9Height="59" ctype="ImageViewObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="768.6517" Y="2.7433" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="hall/plist/bj0.png" Plist="hall/plist/promotor.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_1" ActionTag="1444831280" Tag="311" IconVisible="False" LeftMargin="74.6805" RightMargin="-74.6805" TopMargin="-12.2941" BottomMargin="12.2941" FontSize="20" LabelText="" HorizontalAlignmentType="HT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="0.0000" Y="0.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="1.0000" />
                        <Position X="74.6805" Y="12.2941" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="108" G="59" B="27" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_2" ActionTag="737619841" Tag="312" IconVisible="False" LeftMargin="213.9604" RightMargin="-213.9604" TopMargin="-2.2941" BottomMargin="2.2941" FontSize="20" LabelText="" HorizontalAlignmentType="HT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="0.0000" Y="0.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="213.9604" Y="2.2941" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="108" G="59" B="27" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_3" ActionTag="-1753833524" Tag="313" IconVisible="False" LeftMargin="353.2416" RightMargin="-353.2416" TopMargin="-2.2941" BottomMargin="2.2941" FontSize="20" LabelText="" HorizontalAlignmentType="HT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="0.0000" Y="0.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="353.2416" Y="2.2941" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="108" G="59" B="27" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_4" ActionTag="722126408" Tag="314" IconVisible="False" LeftMargin="492.5211" RightMargin="-492.5211" TopMargin="-2.2941" BottomMargin="2.2941" FontSize="20" LabelText="" HorizontalAlignmentType="HT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="0.0000" Y="0.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="492.5211" Y="2.2941" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="108" G="59" B="27" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_5" ActionTag="-251508574" Tag="315" IconVisible="False" LeftMargin="631.8009" RightMargin="-631.8009" TopMargin="-2.2941" BottomMargin="2.2941" FontSize="20" LabelText="" HorizontalAlignmentType="HT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="0.0000" Y="0.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="631.8009" Y="2.2941" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="108" G="59" B="27" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_6" ActionTag="1743559924" Tag="316" IconVisible="False" LeftMargin="771.0809" RightMargin="-771.0809" TopMargin="-2.2941" BottomMargin="2.2941" FontSize="20" LabelText="" HorizontalAlignmentType="HT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="0.0000" Y="0.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="771.0809" Y="2.2941" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="108" G="59" B="27" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Btn_change" ActionTag="1426870737" Tag="469" IconVisible="False" LeftMargin="692.0000" RightMargin="-846.0000" TopMargin="-29.0000" BottomMargin="-21.0000" TouchEnable="True" FontSize="28" ButtonText="调整" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="124" Scale9Height="28" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                        <Size X="154.0000" Y="50.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="769.0000" Y="4.0000" />
                        <Scale ScaleX="0.6200" ScaleY="0.6200" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <TextColor A="255" R="255" G="255" B="255" />
                        <DisabledFileData Type="Default" Path="Default/Button_Disable.png" Plist="" />
                        <PressedFileData Type="PlistSubImage" Path="hall/plist/an2.png" Plist="hall/plist/promotor.plist" />
                        <NormalFileData Type="PlistSubImage" Path="hall/plist/an1.png" Plist="hall/plist/promotor.plist" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint />
                    <Position X="-28.7700" Y="385.8706" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="-0.0386" Y="0.7350" />
                    <PreSize X="0.0000" Y="0.0000" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="node_item_4" ActionTag="-691515665" Tag="317" IconVisible="True" LeftMargin="-28.7700" RightMargin="774.7700" TopMargin="188.7545" BottomMargin="336.2455" ctype="SingleNodeObjectData">
                    <Size X="0.0000" Y="0.0000" />
                    <Children>
                      <AbstractNodeData Name="Image_1" ActionTag="1285547101" Tag="318" IconVisible="False" LeftMargin="3.3060" RightMargin="-142.3060" TopMargin="-28.2433" BottomMargin="-22.7567" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="63" Scale9Height="59" ctype="ImageViewObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="72.8060" Y="2.7433" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="hall/plist/bj0.png" Plist="hall/plist/promotor.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Image_2" ActionTag="1188710567" Tag="319" IconVisible="False" LeftMargin="142.4714" RightMargin="-281.4714" TopMargin="-28.2433" BottomMargin="-22.7567" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="63" Scale9Height="59" ctype="ImageViewObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="211.9714" Y="2.7433" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="hall/plist/bj0.png" Plist="hall/plist/promotor.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Image_3" ActionTag="312399252" Tag="320" IconVisible="False" LeftMargin="281.4407" RightMargin="-420.4407" TopMargin="-28.2433" BottomMargin="-22.7567" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="63" Scale9Height="59" ctype="ImageViewObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="350.9407" Y="2.7433" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="hall/plist/bj0.png" Plist="hall/plist/promotor.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Image_4" ActionTag="-21415681" Tag="321" IconVisible="False" LeftMargin="421.0115" RightMargin="-560.0115" TopMargin="-28.2433" BottomMargin="-22.7567" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="63" Scale9Height="59" ctype="ImageViewObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="490.5115" Y="2.7433" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="hall/plist/bj0.png" Plist="hall/plist/promotor.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Image_5" ActionTag="-654635399" Tag="322" IconVisible="False" LeftMargin="559.5823" RightMargin="-698.5823" TopMargin="-28.2433" BottomMargin="-22.7567" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="63" Scale9Height="59" ctype="ImageViewObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="629.0823" Y="2.7433" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="hall/plist/bj0.png" Plist="hall/plist/promotor.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Image_6" ActionTag="-1299047130" Tag="323" IconVisible="False" LeftMargin="699.1517" RightMargin="-838.1517" TopMargin="-28.2433" BottomMargin="-22.7567" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="63" Scale9Height="59" ctype="ImageViewObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="768.6517" Y="2.7433" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="hall/plist/bj0.png" Plist="hall/plist/promotor.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_1" ActionTag="2099642502" Tag="324" IconVisible="False" LeftMargin="74.6805" RightMargin="-74.6805" TopMargin="-2.2941" BottomMargin="2.2941" FontSize="20" LabelText="" HorizontalAlignmentType="HT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="0.0000" Y="0.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="74.6805" Y="2.2941" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="108" G="59" B="27" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_2" ActionTag="1658350681" Tag="325" IconVisible="False" LeftMargin="213.9604" RightMargin="-213.9604" TopMargin="-2.2941" BottomMargin="2.2941" FontSize="20" LabelText="" HorizontalAlignmentType="HT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="0.0000" Y="0.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="213.9604" Y="2.2941" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="108" G="59" B="27" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_3" ActionTag="-877165317" Tag="326" IconVisible="False" LeftMargin="353.2416" RightMargin="-353.2416" TopMargin="-2.2941" BottomMargin="2.2941" FontSize="20" LabelText="" HorizontalAlignmentType="HT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="0.0000" Y="0.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="353.2416" Y="2.2941" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="108" G="59" B="27" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_4" ActionTag="1169694128" Tag="327" IconVisible="False" LeftMargin="492.5211" RightMargin="-492.5211" TopMargin="-2.2941" BottomMargin="2.2941" FontSize="20" LabelText="" HorizontalAlignmentType="HT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="0.0000" Y="0.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="492.5211" Y="2.2941" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="108" G="59" B="27" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_5" ActionTag="-1476494812" Tag="328" IconVisible="False" LeftMargin="631.8009" RightMargin="-631.8009" TopMargin="-2.2941" BottomMargin="2.2941" FontSize="20" LabelText="" HorizontalAlignmentType="HT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="0.0000" Y="0.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="631.8009" Y="2.2941" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="108" G="59" B="27" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_6" ActionTag="1800380088" Tag="329" IconVisible="False" LeftMargin="771.0809" RightMargin="-771.0809" TopMargin="-2.2941" BottomMargin="2.2941" FontSize="20" LabelText="" HorizontalAlignmentType="HT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="0.0000" Y="0.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="771.0809" Y="2.2941" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="108" G="59" B="27" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Btn_change" ActionTag="-2043815468" Tag="468" IconVisible="False" LeftMargin="692.0000" RightMargin="-846.0000" TopMargin="-29.0000" BottomMargin="-21.0000" TouchEnable="True" FontSize="28" ButtonText="调整" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="124" Scale9Height="28" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                        <Size X="154.0000" Y="50.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="769.0000" Y="4.0000" />
                        <Scale ScaleX="0.6200" ScaleY="0.6200" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <TextColor A="255" R="255" G="255" B="255" />
                        <DisabledFileData Type="Default" Path="Default/Button_Disable.png" Plist="" />
                        <PressedFileData Type="PlistSubImage" Path="hall/plist/an2.png" Plist="hall/plist/promotor.plist" />
                        <NormalFileData Type="PlistSubImage" Path="hall/plist/an1.png" Plist="hall/plist/promotor.plist" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint />
                    <Position X="-28.7700" Y="336.2455" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="-0.0386" Y="0.6405" />
                    <PreSize X="0.0000" Y="0.0000" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="node_item_5" ActionTag="-43146261" Tag="330" IconVisible="True" LeftMargin="-28.7700" RightMargin="774.7700" TopMargin="238.3796" BottomMargin="286.6204" ctype="SingleNodeObjectData">
                    <Size X="0.0000" Y="0.0000" />
                    <Children>
                      <AbstractNodeData Name="Image_1" ActionTag="1097912549" Tag="331" IconVisible="False" LeftMargin="3.3060" RightMargin="-142.3060" TopMargin="-28.2433" BottomMargin="-22.7567" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="63" Scale9Height="59" ctype="ImageViewObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="72.8060" Y="2.7433" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="hall/plist/bj0.png" Plist="hall/plist/promotor.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Image_2" ActionTag="-1328592237" Tag="332" IconVisible="False" LeftMargin="142.4714" RightMargin="-281.4714" TopMargin="-28.2433" BottomMargin="-22.7567" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="63" Scale9Height="59" ctype="ImageViewObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="211.9714" Y="2.7433" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="hall/plist/bj0.png" Plist="hall/plist/promotor.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Image_3" ActionTag="1360102123" Tag="333" IconVisible="False" LeftMargin="281.4407" RightMargin="-420.4407" TopMargin="-28.2433" BottomMargin="-22.7567" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="63" Scale9Height="59" ctype="ImageViewObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="350.9407" Y="2.7433" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="hall/plist/bj0.png" Plist="hall/plist/promotor.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Image_4" ActionTag="-1196574923" Tag="334" IconVisible="False" LeftMargin="421.0115" RightMargin="-560.0115" TopMargin="-28.2433" BottomMargin="-22.7567" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="63" Scale9Height="59" ctype="ImageViewObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="490.5115" Y="2.7433" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="hall/plist/bj0.png" Plist="hall/plist/promotor.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Image_5" ActionTag="-1737689881" Tag="335" IconVisible="False" LeftMargin="559.5823" RightMargin="-698.5823" TopMargin="-28.2433" BottomMargin="-22.7567" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="63" Scale9Height="59" ctype="ImageViewObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="629.0823" Y="2.7433" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="hall/plist/bj0.png" Plist="hall/plist/promotor.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Image_6" ActionTag="-1284069196" Tag="336" IconVisible="False" LeftMargin="699.1517" RightMargin="-838.1517" TopMargin="-28.2433" BottomMargin="-22.7567" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="63" Scale9Height="59" ctype="ImageViewObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="768.6517" Y="2.7433" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="hall/plist/bj0.png" Plist="hall/plist/promotor.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_1" ActionTag="-1653115163" Tag="337" IconVisible="False" LeftMargin="74.6805" RightMargin="-74.6805" TopMargin="-2.2941" BottomMargin="2.2941" FontSize="20" LabelText="" HorizontalAlignmentType="HT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="0.0000" Y="0.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="74.6805" Y="2.2941" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="108" G="59" B="27" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_2" ActionTag="582662490" Tag="338" IconVisible="False" LeftMargin="213.9604" RightMargin="-213.9604" TopMargin="-2.2941" BottomMargin="2.2941" FontSize="20" LabelText="" HorizontalAlignmentType="HT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="0.0000" Y="0.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="213.9604" Y="2.2941" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="108" G="59" B="27" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_3" ActionTag="32715507" Tag="339" IconVisible="False" LeftMargin="353.2416" RightMargin="-353.2416" TopMargin="-2.2941" BottomMargin="2.2941" FontSize="20" LabelText="" HorizontalAlignmentType="HT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="0.0000" Y="0.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="353.2416" Y="2.2941" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="108" G="59" B="27" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_4" ActionTag="-214955437" Tag="340" IconVisible="False" LeftMargin="492.5211" RightMargin="-492.5211" TopMargin="-2.2941" BottomMargin="2.2941" FontSize="20" LabelText="" HorizontalAlignmentType="HT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="0.0000" Y="0.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="492.5211" Y="2.2941" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="108" G="59" B="27" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_5" ActionTag="-1261740963" Tag="341" IconVisible="False" LeftMargin="631.8009" RightMargin="-631.8009" TopMargin="-2.2941" BottomMargin="2.2941" FontSize="20" LabelText="" HorizontalAlignmentType="HT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="0.0000" Y="0.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="631.8009" Y="2.2941" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="108" G="59" B="27" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_6" ActionTag="721842022" Tag="342" IconVisible="False" LeftMargin="771.0809" RightMargin="-771.0809" TopMargin="-2.2941" BottomMargin="2.2941" FontSize="20" LabelText="" HorizontalAlignmentType="HT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="0.0000" Y="0.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="771.0809" Y="2.2941" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="108" G="59" B="27" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Btn_change" ActionTag="-880516290" Tag="464" IconVisible="False" LeftMargin="692.0000" RightMargin="-846.0000" TopMargin="-29.0000" BottomMargin="-21.0000" TouchEnable="True" FontSize="28" ButtonText="调整" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="124" Scale9Height="28" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                        <Size X="154.0000" Y="50.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="769.0000" Y="4.0000" />
                        <Scale ScaleX="0.6200" ScaleY="0.6200" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <TextColor A="255" R="255" G="255" B="255" />
                        <DisabledFileData Type="Default" Path="Default/Button_Disable.png" Plist="" />
                        <PressedFileData Type="PlistSubImage" Path="hall/plist/an2.png" Plist="hall/plist/promotor.plist" />
                        <NormalFileData Type="PlistSubImage" Path="hall/plist/an1.png" Plist="hall/plist/promotor.plist" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint />
                    <Position X="-28.7700" Y="286.6204" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="-0.0386" Y="0.5459" />
                    <PreSize X="0.0000" Y="0.0000" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="node_item_6" ActionTag="1919817166" Tag="343" IconVisible="True" LeftMargin="-28.7700" RightMargin="774.7700" TopMargin="288.0047" BottomMargin="236.9953" ctype="SingleNodeObjectData">
                    <Size X="0.0000" Y="0.0000" />
                    <Children>
                      <AbstractNodeData Name="Image_1" ActionTag="-1994980929" Tag="344" IconVisible="False" LeftMargin="3.3060" RightMargin="-142.3060" TopMargin="-28.2433" BottomMargin="-22.7567" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="63" Scale9Height="59" ctype="ImageViewObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="72.8060" Y="2.7433" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="hall/plist/bj0.png" Plist="hall/plist/promotor.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Image_2" ActionTag="-792575726" Tag="345" IconVisible="False" LeftMargin="142.4714" RightMargin="-281.4714" TopMargin="-28.2433" BottomMargin="-22.7567" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="63" Scale9Height="59" ctype="ImageViewObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="211.9714" Y="2.7433" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="hall/plist/bj0.png" Plist="hall/plist/promotor.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Image_3" ActionTag="-1081902365" Tag="346" IconVisible="False" LeftMargin="281.4407" RightMargin="-420.4407" TopMargin="-28.2433" BottomMargin="-22.7567" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="63" Scale9Height="59" ctype="ImageViewObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="350.9407" Y="2.7433" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="hall/plist/bj0.png" Plist="hall/plist/promotor.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Image_4" ActionTag="-1162874170" Tag="347" IconVisible="False" LeftMargin="421.0115" RightMargin="-560.0115" TopMargin="-28.2433" BottomMargin="-22.7567" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="63" Scale9Height="59" ctype="ImageViewObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="490.5115" Y="2.7433" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="hall/plist/bj0.png" Plist="hall/plist/promotor.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Image_5" ActionTag="32038418" Tag="348" IconVisible="False" LeftMargin="559.5823" RightMargin="-698.5823" TopMargin="-28.2433" BottomMargin="-22.7567" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="63" Scale9Height="59" ctype="ImageViewObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="629.0823" Y="2.7433" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="hall/plist/bj0.png" Plist="hall/plist/promotor.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Image_6" ActionTag="1034881369" Tag="349" IconVisible="False" LeftMargin="699.1517" RightMargin="-838.1517" TopMargin="-28.2433" BottomMargin="-22.7567" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="63" Scale9Height="59" ctype="ImageViewObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="768.6517" Y="2.7433" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="hall/plist/bj0.png" Plist="hall/plist/promotor.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_1" ActionTag="-1880549349" Tag="350" IconVisible="False" LeftMargin="74.6805" RightMargin="-74.6805" TopMargin="-2.2941" BottomMargin="2.2941" FontSize="20" LabelText="" HorizontalAlignmentType="HT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="0.0000" Y="0.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="74.6805" Y="2.2941" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="108" G="59" B="27" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_2" ActionTag="-1409744347" Tag="351" IconVisible="False" LeftMargin="213.9604" RightMargin="-213.9604" TopMargin="-2.2941" BottomMargin="2.2941" FontSize="20" LabelText="" HorizontalAlignmentType="HT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="0.0000" Y="0.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="213.9604" Y="2.2941" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="108" G="59" B="27" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_3" ActionTag="1040246769" Tag="352" IconVisible="False" LeftMargin="353.2416" RightMargin="-353.2416" TopMargin="-2.2941" BottomMargin="2.2941" FontSize="20" LabelText="" HorizontalAlignmentType="HT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="0.0000" Y="0.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="353.2416" Y="2.2941" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="108" G="59" B="27" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_4" ActionTag="-894916531" Tag="353" IconVisible="False" LeftMargin="492.5211" RightMargin="-492.5211" TopMargin="-2.2941" BottomMargin="2.2941" FontSize="20" LabelText="" HorizontalAlignmentType="HT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="0.0000" Y="0.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="492.5211" Y="2.2941" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="108" G="59" B="27" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_5" ActionTag="-1679160002" Tag="354" IconVisible="False" LeftMargin="631.8009" RightMargin="-631.8009" TopMargin="-2.2941" BottomMargin="2.2941" FontSize="20" LabelText="" HorizontalAlignmentType="HT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="0.0000" Y="0.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="631.8009" Y="2.2941" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="108" G="59" B="27" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_6" ActionTag="1592415631" Tag="355" IconVisible="False" LeftMargin="771.0809" RightMargin="-771.0809" TopMargin="-2.2941" BottomMargin="2.2941" FontSize="20" LabelText="" HorizontalAlignmentType="HT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="0.0000" Y="0.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="771.0809" Y="2.2941" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="108" G="59" B="27" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Btn_change" ActionTag="1799969917" Tag="467" IconVisible="False" LeftMargin="692.0000" RightMargin="-846.0000" TopMargin="-29.0000" BottomMargin="-21.0000" TouchEnable="True" FontSize="28" ButtonText="调整" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="124" Scale9Height="28" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                        <Size X="154.0000" Y="50.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="769.0000" Y="4.0000" />
                        <Scale ScaleX="0.6200" ScaleY="0.6200" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <TextColor A="255" R="255" G="255" B="255" />
                        <DisabledFileData Type="Default" Path="Default/Button_Disable.png" Plist="" />
                        <PressedFileData Type="PlistSubImage" Path="hall/plist/an2.png" Plist="hall/plist/promotor.plist" />
                        <NormalFileData Type="PlistSubImage" Path="hall/plist/an1.png" Plist="hall/plist/promotor.plist" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint />
                    <Position X="-28.7700" Y="236.9953" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="-0.0386" Y="0.4514" />
                    <PreSize X="0.0000" Y="0.0000" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="node_item_7" ActionTag="-2099173394" Tag="356" IconVisible="True" LeftMargin="-28.7700" RightMargin="774.7700" TopMargin="337.6298" BottomMargin="187.3702" ctype="SingleNodeObjectData">
                    <Size X="0.0000" Y="0.0000" />
                    <Children>
                      <AbstractNodeData Name="Image_1" ActionTag="1223877691" Tag="357" IconVisible="False" LeftMargin="3.3060" RightMargin="-142.3060" TopMargin="-28.2433" BottomMargin="-22.7567" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="63" Scale9Height="59" ctype="ImageViewObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="72.8060" Y="2.7433" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="hall/plist/bj0.png" Plist="hall/plist/promotor.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Image_2" ActionTag="-1065192030" Tag="358" IconVisible="False" LeftMargin="142.4714" RightMargin="-281.4714" TopMargin="-28.2433" BottomMargin="-22.7567" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="63" Scale9Height="59" ctype="ImageViewObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="211.9714" Y="2.7433" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="hall/plist/bj0.png" Plist="hall/plist/promotor.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Image_3" ActionTag="-87139252" Tag="359" IconVisible="False" LeftMargin="281.4407" RightMargin="-420.4407" TopMargin="-28.2433" BottomMargin="-22.7567" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="63" Scale9Height="59" ctype="ImageViewObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="350.9407" Y="2.7433" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="hall/plist/bj0.png" Plist="hall/plist/promotor.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Image_4" ActionTag="434803122" Tag="360" IconVisible="False" LeftMargin="421.0115" RightMargin="-560.0115" TopMargin="-28.2433" BottomMargin="-22.7567" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="63" Scale9Height="59" ctype="ImageViewObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="490.5115" Y="2.7433" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="hall/plist/bj0.png" Plist="hall/plist/promotor.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Image_5" ActionTag="-1141952985" Tag="361" IconVisible="False" LeftMargin="559.5823" RightMargin="-698.5823" TopMargin="-28.2433" BottomMargin="-22.7567" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="63" Scale9Height="59" ctype="ImageViewObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="629.0823" Y="2.7433" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="hall/plist/bj0.png" Plist="hall/plist/promotor.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Image_6" ActionTag="1583636100" Tag="362" IconVisible="False" LeftMargin="699.1517" RightMargin="-838.1517" TopMargin="-28.2433" BottomMargin="-22.7567" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="63" Scale9Height="59" ctype="ImageViewObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="768.6517" Y="2.7433" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="hall/plist/bj0.png" Plist="hall/plist/promotor.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_1" ActionTag="-1003686044" Tag="363" IconVisible="False" LeftMargin="74.6805" RightMargin="-74.6805" TopMargin="-2.2941" BottomMargin="2.2941" FontSize="20" LabelText="" HorizontalAlignmentType="HT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="0.0000" Y="0.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="74.6805" Y="2.2941" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="108" G="59" B="27" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_2" ActionTag="321905159" Tag="364" IconVisible="False" LeftMargin="213.9604" RightMargin="-213.9604" TopMargin="-2.2941" BottomMargin="2.2941" FontSize="20" LabelText="" HorizontalAlignmentType="HT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="0.0000" Y="0.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="213.9604" Y="2.2941" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="108" G="59" B="27" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_3" ActionTag="1399155760" Tag="365" IconVisible="False" LeftMargin="353.2416" RightMargin="-353.2416" TopMargin="-2.2941" BottomMargin="2.2941" FontSize="20" LabelText="" HorizontalAlignmentType="HT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="0.0000" Y="0.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="353.2416" Y="2.2941" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="108" G="59" B="27" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_4" ActionTag="-2116893369" Tag="366" IconVisible="False" LeftMargin="492.5211" RightMargin="-492.5211" TopMargin="-2.2941" BottomMargin="2.2941" FontSize="20" LabelText="" HorizontalAlignmentType="HT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="0.0000" Y="0.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="492.5211" Y="2.2941" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="108" G="59" B="27" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_5" ActionTag="1905271045" Tag="367" IconVisible="False" LeftMargin="631.8009" RightMargin="-631.8009" TopMargin="-2.2941" BottomMargin="2.2941" FontSize="20" LabelText="" HorizontalAlignmentType="HT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="0.0000" Y="0.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="631.8009" Y="2.2941" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="108" G="59" B="27" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_6" ActionTag="-1861441762" Tag="368" IconVisible="False" LeftMargin="771.0809" RightMargin="-771.0809" TopMargin="-2.2941" BottomMargin="2.2941" FontSize="20" LabelText="" HorizontalAlignmentType="HT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="0.0000" Y="0.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="771.0809" Y="2.2941" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="108" G="59" B="27" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Btn_change" ActionTag="-233768515" Tag="465" IconVisible="False" LeftMargin="692.0000" RightMargin="-846.0000" TopMargin="-29.0000" BottomMargin="-21.0000" TouchEnable="True" FontSize="28" ButtonText="调整" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="124" Scale9Height="28" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                        <Size X="154.0000" Y="50.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="769.0000" Y="4.0000" />
                        <Scale ScaleX="0.6200" ScaleY="0.6200" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <TextColor A="255" R="255" G="255" B="255" />
                        <DisabledFileData Type="Default" Path="Default/Button_Disable.png" Plist="" />
                        <PressedFileData Type="PlistSubImage" Path="hall/plist/an2.png" Plist="hall/plist/promotor.plist" />
                        <NormalFileData Type="PlistSubImage" Path="hall/plist/an1.png" Plist="hall/plist/promotor.plist" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint />
                    <Position X="-28.7700" Y="187.3702" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="-0.0386" Y="0.3569" />
                    <PreSize X="0.0000" Y="0.0000" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="node_item_8" ActionTag="1025933442" Tag="369" IconVisible="True" LeftMargin="-28.7700" RightMargin="774.7700" TopMargin="387.2549" BottomMargin="137.7451" ctype="SingleNodeObjectData">
                    <Size X="0.0000" Y="0.0000" />
                    <Children>
                      <AbstractNodeData Name="Image_1" ActionTag="-642874414" Tag="370" IconVisible="False" LeftMargin="3.3060" RightMargin="-142.3060" TopMargin="-28.2433" BottomMargin="-22.7567" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="63" Scale9Height="59" ctype="ImageViewObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="72.8060" Y="2.7433" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="hall/plist/bj0.png" Plist="hall/plist/promotor.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Image_2" ActionTag="-204052091" Tag="371" IconVisible="False" LeftMargin="142.4714" RightMargin="-281.4714" TopMargin="-28.2433" BottomMargin="-22.7567" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="63" Scale9Height="59" ctype="ImageViewObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="211.9714" Y="2.7433" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="hall/plist/bj0.png" Plist="hall/plist/promotor.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Image_3" ActionTag="1782226634" Tag="372" IconVisible="False" LeftMargin="281.4407" RightMargin="-420.4407" TopMargin="-28.2433" BottomMargin="-22.7567" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="63" Scale9Height="59" ctype="ImageViewObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="350.9407" Y="2.7433" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="hall/plist/bj0.png" Plist="hall/plist/promotor.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Image_4" ActionTag="1028034615" Tag="373" IconVisible="False" LeftMargin="421.0115" RightMargin="-560.0115" TopMargin="-28.2433" BottomMargin="-22.7567" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="63" Scale9Height="59" ctype="ImageViewObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="490.5115" Y="2.7433" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="hall/plist/bj0.png" Plist="hall/plist/promotor.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Image_5" ActionTag="1220354317" Tag="374" IconVisible="False" LeftMargin="559.5823" RightMargin="-698.5823" TopMargin="-28.2433" BottomMargin="-22.7567" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="63" Scale9Height="59" ctype="ImageViewObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="629.0823" Y="2.7433" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="hall/plist/bj0.png" Plist="hall/plist/promotor.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Image_6" ActionTag="766904091" Tag="375" IconVisible="False" LeftMargin="699.1517" RightMargin="-838.1517" TopMargin="-28.2433" BottomMargin="-22.7567" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="63" Scale9Height="59" ctype="ImageViewObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="768.6517" Y="2.7433" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="hall/plist/bj0.png" Plist="hall/plist/promotor.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_1" ActionTag="-146661847" Tag="376" IconVisible="False" LeftMargin="74.6805" RightMargin="-74.6805" TopMargin="-2.2941" BottomMargin="2.2941" FontSize="20" LabelText="" HorizontalAlignmentType="HT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="0.0000" Y="0.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="74.6805" Y="2.2941" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="108" G="59" B="27" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_2" ActionTag="838773068" Tag="377" IconVisible="False" LeftMargin="213.9604" RightMargin="-213.9604" TopMargin="-2.2941" BottomMargin="2.2941" FontSize="20" LabelText="" HorizontalAlignmentType="HT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="0.0000" Y="0.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="213.9604" Y="2.2941" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="108" G="59" B="27" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_3" ActionTag="-772909763" Tag="378" IconVisible="False" LeftMargin="353.2416" RightMargin="-353.2416" TopMargin="-2.2941" BottomMargin="2.2941" FontSize="20" LabelText="" HorizontalAlignmentType="HT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="0.0000" Y="0.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="353.2416" Y="2.2941" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="108" G="59" B="27" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_4" ActionTag="1855100974" Tag="379" IconVisible="False" LeftMargin="492.5211" RightMargin="-492.5211" TopMargin="-2.2941" BottomMargin="2.2941" FontSize="20" LabelText="" HorizontalAlignmentType="HT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="0.0000" Y="0.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="492.5211" Y="2.2941" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="108" G="59" B="27" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_5" ActionTag="797207521" Tag="380" IconVisible="False" LeftMargin="631.8009" RightMargin="-631.8009" TopMargin="-2.2941" BottomMargin="2.2941" FontSize="20" LabelText="" HorizontalAlignmentType="HT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="0.0000" Y="0.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="631.8009" Y="2.2941" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="108" G="59" B="27" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_6" ActionTag="-289188306" Tag="381" IconVisible="False" LeftMargin="771.0809" RightMargin="-771.0809" TopMargin="-2.2941" BottomMargin="2.2941" FontSize="20" LabelText="" HorizontalAlignmentType="HT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="0.0000" Y="0.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="771.0809" Y="2.2941" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="108" G="59" B="27" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Btn_change" ActionTag="1640257656" Tag="466" IconVisible="False" LeftMargin="692.0000" RightMargin="-846.0000" TopMargin="-29.0000" BottomMargin="-21.0000" TouchEnable="True" FontSize="28" ButtonText="调整" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="124" Scale9Height="28" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                        <Size X="154.0000" Y="50.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="769.0000" Y="4.0000" />
                        <Scale ScaleX="0.6200" ScaleY="0.6200" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <TextColor A="255" R="255" G="255" B="255" />
                        <DisabledFileData Type="Default" Path="Default/Button_Disable.png" Plist="" />
                        <PressedFileData Type="PlistSubImage" Path="hall/plist/an2.png" Plist="hall/plist/promotor.plist" />
                        <NormalFileData Type="PlistSubImage" Path="hall/plist/an1.png" Plist="hall/plist/promotor.plist" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint />
                    <Position X="-28.7700" Y="137.7451" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="-0.0386" Y="0.2624" />
                    <PreSize X="0.0000" Y="0.0000" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Node_pop" Visible="False" ActionTag="-977995540" Tag="598" IconVisible="True" LeftMargin="71.7806" RightMargin="674.2194" TopMargin="455.7785" BottomMargin="69.2215" ctype="SingleNodeObjectData">
                    <Size X="0.0000" Y="0.0000" />
                    <Children>
                      <AbstractNodeData Name="Button_Save_0" ActionTag="1973626454" Tag="599" IconVisible="False" LeftMargin="270.1149" RightMargin="-330.1149" TopMargin="-267.2369" BottomMargin="237.2369" TouchEnable="True" FontSize="30" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="-15" Scale9OriginY="-11" Scale9Width="30" Scale9Height="22" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                        <Size X="60.0000" Y="30.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="300.1149" Y="252.2369" />
                        <Scale ScaleX="22.0988" ScaleY="25.2764" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <TextColor A="255" R="255" G="255" B="255" />
                        <DisabledFileData Type="Default" Path="Default/Button_Disable.png" Plist="" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Image_7" ActionTag="-1819389526" Tag="600" IconVisible="False" LeftMargin="81.1370" RightMargin="-567.1370" TopMargin="-426.5960" BottomMargin="115.5960" Scale9Enable="True" LeftEage="19" RightEage="24" TopEage="15" BottomEage="14" Scale9OriginX="19" Scale9OriginY="15" Scale9Width="198" Scale9Height="142" ctype="ImageViewObjectData">
                        <Size X="486.0000" Y="311.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="324.1370" Y="271.0960" />
                        <Scale ScaleX="1.5197" ScaleY="1.5029" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="tkbj.png" Plist="hall/plist/gui-agentpop.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="input_bg1" ActionTag="1242087827" Tag="601" IconVisible="False" LeftMargin="211.4099" RightMargin="-589.4099" TopMargin="-467.6632" BottomMargin="414.6632" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="17" Scale9Height="15" ctype="ImageViewObjectData">
                        <Size X="378.0000" Y="53.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="400.4099" Y="441.1632" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="kko.png" Plist="hall/plist/gui-agentpop.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="input_bg2" ActionTag="-774111457" Tag="602" IconVisible="False" LeftMargin="212.6930" RightMargin="-590.6930" TopMargin="-295.8741" BottomMargin="242.8741" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="17" Scale9Height="15" ctype="ImageViewObjectData">
                        <Size X="378.0000" Y="53.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="401.6930" Y="269.3741" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="kko.png" Plist="hall/plist/gui-agentpop.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="input_bg4" ActionTag="-514873121" Tag="603" IconVisible="False" LeftMargin="336.2946" RightMargin="-587.2946" TopMargin="-210.0772" BottomMargin="157.0772" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="17" Scale9Height="15" ctype="ImageViewObjectData">
                        <Size X="251.0000" Y="53.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="461.7946" Y="183.5772" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="kko.png" Plist="hall/plist/gui-agentpop.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_33" ActionTag="669416581" Tag="604" IconVisible="False" LeftMargin="50.5349" RightMargin="-155.5349" TopMargin="-455.3302" BottomMargin="425.3302" FontSize="30" LabelText="账户ID:" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="105.0000" Y="30.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="103.0349" Y="440.3302" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="108" G="59" B="27" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_33_0" ActionTag="216245842" Tag="605" IconVisible="False" LeftMargin="55.6547" RightMargin="-130.6547" TopMargin="-372.8934" BottomMargin="342.8934" FontSize="30" LabelText="等级:" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="75.0000" Y="30.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="93.1547" Y="357.8934" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="108" G="59" B="27" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_33_1" ActionTag="1695640985" Tag="606" IconVisible="False" LeftMargin="64.7683" RightMargin="-139.7683" TopMargin="-283.3313" BottomMargin="253.3313" FontSize="30" LabelText="占成:" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="75.0000" Y="30.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="102.2683" Y="268.3313" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="108" G="59" B="27" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_33_2" ActionTag="1965024417" Tag="607" IconVisible="False" LeftMargin="50.1147" RightMargin="-305.1147" TopMargin="-197.1501" BottomMargin="167.1501" FontSize="30" LabelText="禁止创建下级代理:" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="255.0000" Y="30.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="177.6147" Y="182.1501" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="108" G="59" B="27" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Button_Cancel" ActionTag="-1736571297" Tag="608" IconVisible="False" LeftMargin="106.1852" RightMargin="-231.1852" TopMargin="-122.8386" BottomMargin="72.8386" TouchEnable="True" FontSize="30" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="95" Scale9Height="28" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                        <Size X="125.0000" Y="50.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="168.6852" Y="97.8386" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <TextColor A="255" R="255" G="255" B="255" />
                        <DisabledFileData Type="Default" Path="Default/Button_Disable.png" Plist="" />
                        <PressedFileData Type="PlistSubImage" Path="qx2.png" Plist="hall/plist/gui-agentpop.plist" />
                        <NormalFileData Type="PlistSubImage" Path="qx1.png" Plist="hall/plist/gui-agentpop.plist" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Button_Save" ActionTag="2053686417" Tag="609" IconVisible="False" LeftMargin="422.5207" RightMargin="-547.5207" TopMargin="-126.9428" BottomMargin="76.9428" TouchEnable="True" FontSize="30" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="95" Scale9Height="28" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                        <Size X="125.0000" Y="50.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="485.0207" Y="101.9428" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <TextColor A="255" R="255" G="255" B="255" />
                        <DisabledFileData Type="Default" Path="Default/Button_Disable.png" Plist="" />
                        <PressedFileData Type="PlistSubImage" Path="bc2.png" Plist="hall/plist/gui-agentpop.plist" />
                        <NormalFileData Type="PlistSubImage" Path="bc1.png" Plist="hall/plist/gui-agentpop.plist" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="node_pop" ActionTag="-1785410848" Tag="610" IconVisible="False" LeftMargin="214.6800" RightMargin="-592.6800" TopMargin="-323.5200" BottomMargin="-46.4800" TouchEnable="True" ClipAble="False" BackColorAlpha="100" ColorAngle="0.0000" Scale9Width="1" Scale9Height="1" ctype="PanelObjectData">
                        <Size X="378.0000" Y="370.0000" />
                        <Children>
                          <AbstractNodeData Name="IMG_selectBg" ActionTag="115284466" Tag="611" IconVisible="False" LeftMargin="130.5908" RightMargin="130.4092" TopMargin="151.2419" BottomMargin="139.7581" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="63" Scale9Height="59" ctype="ImageViewObjectData">
                            <Size X="117.0000" Y="79.0000" />
                            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                            <Position X="189.0908" Y="179.2581" />
                            <Scale ScaleX="3.2306" ScaleY="4.8763" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition X="0.5002" Y="0.4845" />
                            <PreSize X="0.3095" Y="0.2135" />
                            <FileData Type="PlistSubImage" Path="hall/plist/bj0.png" Plist="hall/plist/promotor.plist" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="IMG_line1" ActionTag="1336295473" Tag="612" IconVisible="False" LeftMargin="36.5588" RightMargin="33.4412" TopMargin="26.3811" BottomMargin="341.6189" ctype="SpriteObjectData">
                            <Size X="308.0000" Y="2.0000" />
                            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                            <Position X="190.5588" Y="342.6189" />
                            <Scale ScaleX="1.2200" ScaleY="1.0000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition X="0.5041" Y="0.9260" />
                            <PreSize X="0.8148" Y="0.0054" />
                            <FileData Type="PlistSubImage" Path="gui-hall-cash-select-line.png" Plist="hall/image/gui-hall-exchange.plist" />
                            <BlendFunc Src="1" Dst="771" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="IMG_line2_1" ActionTag="-2042455289" Tag="613" IconVisible="False" LeftMargin="36.5588" RightMargin="33.4412" TopMargin="316.2159" BottomMargin="51.7841" ctype="SpriteObjectData">
                            <Size X="308.0000" Y="2.0000" />
                            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                            <Position X="190.5588" Y="52.7841" />
                            <Scale ScaleX="1.2200" ScaleY="1.0000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition X="0.5041" Y="0.1427" />
                            <PreSize X="0.8148" Y="0.0054" />
                            <FileData Type="PlistSubImage" Path="gui-hall-cash-select-line.png" Plist="hall/image/gui-hall-exchange.plist" />
                            <BlendFunc Src="1" Dst="771" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="IMG_line2_0" ActionTag="-25617728" Tag="614" IconVisible="False" LeftMargin="36.5588" RightMargin="33.4412" TopMargin="283.6339" BottomMargin="84.3661" ctype="SpriteObjectData">
                            <Size X="308.0000" Y="2.0000" />
                            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                            <Position X="190.5588" Y="85.3661" />
                            <Scale ScaleX="1.2200" ScaleY="1.0000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition X="0.5041" Y="0.2307" />
                            <PreSize X="0.8148" Y="0.0054" />
                            <FileData Type="PlistSubImage" Path="gui-hall-cash-select-line.png" Plist="hall/image/gui-hall-exchange.plist" />
                            <BlendFunc Src="1" Dst="771" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="IMG_line3" ActionTag="-1729184307" Tag="615" IconVisible="False" LeftMargin="36.0795" RightMargin="33.9205" TopMargin="252.3925" BottomMargin="115.6075" ctype="SpriteObjectData">
                            <Size X="308.0000" Y="2.0000" />
                            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                            <Position X="190.0795" Y="116.6075" />
                            <Scale ScaleX="1.2200" ScaleY="1.0000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition X="0.5029" Y="0.3152" />
                            <PreSize X="0.8148" Y="0.0054" />
                            <FileData Type="PlistSubImage" Path="gui-hall-cash-select-line.png" Plist="hall/image/gui-hall-exchange.plist" />
                            <BlendFunc Src="1" Dst="771" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="IMG_line2" ActionTag="1066200006" Tag="616" IconVisible="False" LeftMargin="36.5588" RightMargin="33.4412" TopMargin="59.6112" BottomMargin="308.3888" ctype="SpriteObjectData">
                            <Size X="308.0000" Y="2.0000" />
                            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                            <Position X="190.5588" Y="309.3888" />
                            <Scale ScaleX="1.2200" ScaleY="1.0000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition X="0.5041" Y="0.8362" />
                            <PreSize X="0.8148" Y="0.0054" />
                            <FileData Type="PlistSubImage" Path="gui-hall-cash-select-line.png" Plist="hall/image/gui-hall-exchange.plist" />
                            <BlendFunc Src="1" Dst="771" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="IMG_line2_2" ActionTag="1065988295" Tag="617" IconVisible="False" LeftMargin="36.5588" RightMargin="33.4412" TopMargin="90.8397" BottomMargin="277.1603" ctype="SpriteObjectData">
                            <Size X="308.0000" Y="2.0000" />
                            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                            <Position X="190.5588" Y="278.1603" />
                            <Scale ScaleX="1.2200" ScaleY="1.0000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition X="0.5041" Y="0.7518" />
                            <PreSize X="0.8148" Y="0.0054" />
                            <FileData Type="PlistSubImage" Path="gui-hall-cash-select-line.png" Plist="hall/image/gui-hall-exchange.plist" />
                            <BlendFunc Src="1" Dst="771" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="IMG_line2_3" ActionTag="382416566" Tag="618" IconVisible="False" LeftMargin="36.5588" RightMargin="33.4412" TopMargin="125.0695" BottomMargin="242.9305" ctype="SpriteObjectData">
                            <Size X="308.0000" Y="2.0000" />
                            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                            <Position X="190.5588" Y="243.9305" />
                            <Scale ScaleX="1.2200" ScaleY="1.0000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition X="0.5041" Y="0.6593" />
                            <PreSize X="0.8148" Y="0.0054" />
                            <FileData Type="PlistSubImage" Path="gui-hall-cash-select-line.png" Plist="hall/image/gui-hall-exchange.plist" />
                            <BlendFunc Src="1" Dst="771" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="IMG_line2_4" ActionTag="-435547794" Tag="619" IconVisible="False" LeftMargin="36.5588" RightMargin="33.4412" TopMargin="157.2995" BottomMargin="210.7005" ctype="SpriteObjectData">
                            <Size X="308.0000" Y="2.0000" />
                            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                            <Position X="190.5588" Y="211.7005" />
                            <Scale ScaleX="1.2200" ScaleY="1.0000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition X="0.5041" Y="0.5722" />
                            <PreSize X="0.8148" Y="0.0054" />
                            <FileData Type="PlistSubImage" Path="gui-hall-cash-select-line.png" Plist="hall/image/gui-hall-exchange.plist" />
                            <BlendFunc Src="1" Dst="771" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="IMG_line2_4_0" ActionTag="-2050048279" Tag="620" IconVisible="False" LeftMargin="36.5588" RightMargin="33.4412" TopMargin="189.5298" BottomMargin="178.4702" ctype="SpriteObjectData">
                            <Size X="308.0000" Y="2.0000" />
                            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                            <Position X="190.5588" Y="179.4702" />
                            <Scale ScaleX="1.2200" ScaleY="1.0000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition X="0.5041" Y="0.4851" />
                            <PreSize X="0.8148" Y="0.0054" />
                            <FileData Type="PlistSubImage" Path="gui-hall-cash-select-line.png" Plist="hall/image/gui-hall-exchange.plist" />
                            <BlendFunc Src="1" Dst="771" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="IMG_line2_6" ActionTag="-683433185" Tag="621" IconVisible="False" LeftMargin="33.9210" RightMargin="36.0790" TopMargin="220.4492" BottomMargin="147.5508" ctype="SpriteObjectData">
                            <Size X="308.0000" Y="2.0000" />
                            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                            <Position X="187.9210" Y="148.5508" />
                            <Scale ScaleX="1.2200" ScaleY="1.0000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition X="0.4971" Y="0.4015" />
                            <PreSize X="0.8148" Y="0.0054" />
                            <FileData Type="PlistSubImage" Path="gui-hall-cash-select-line.png" Plist="hall/image/gui-hall-exchange.plist" />
                            <BlendFunc Src="1" Dst="771" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="IMG_line2_6_0" ActionTag="1039812765" Tag="622" IconVisible="False" LeftMargin="33.9191" RightMargin="36.0809" TopMargin="352.4496" BottomMargin="15.5504" ctype="SpriteObjectData">
                            <Size X="308.0000" Y="2.0000" />
                            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                            <Position X="187.9191" Y="16.5504" />
                            <Scale ScaleX="1.2200" ScaleY="1.0000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition X="0.4971" Y="0.0447" />
                            <PreSize X="0.8148" Y="0.0054" />
                            <FileData Type="PlistSubImage" Path="gui-hall-cash-select-line.png" Plist="hall/image/gui-hall-exchange.plist" />
                            <BlendFunc Src="1" Dst="771" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="node_1" ActionTag="-1830052509" Tag="623" IconVisible="False" LeftMargin="0.7501" RightMargin="-2.7501" TopMargin="-2.2288" BottomMargin="343.2288" ClipAble="False" BackColorAlpha="100" ColorAngle="0.0000" Scale9Width="1" Scale9Height="1" ctype="PanelObjectData">
                            <Size X="380.0000" Y="29.0000" />
                            <Children>
                              <AbstractNodeData Name="BTN_select" ActionTag="1824722913" Tag="624" IconVisible="False" LeftMargin="6.5000" RightMargin="-3.5000" TopMargin="-2.0000" BottomMargin="-3.0000" TouchEnable="True" FontSize="14" Scale9Width="1" Scale9Height="1" OutlineSize="0" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ctype="ButtonObjectData">
                                <Size X="377.0000" Y="34.0000" />
                                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                                <Position X="195.0000" Y="14.0000" />
                                <Scale ScaleX="1.0000" ScaleY="0.8925" />
                                <CColor A="255" R="255" G="255" B="255" />
                                <PrePosition X="0.5132" Y="0.4828" />
                                <PreSize X="0.9921" Y="1.1724" />
                                <TextColor A="255" R="255" G="255" B="255" />
                                <NormalFileData Type="PlistSubImage" Path="gui-texture-null.png" Plist="hall/image/gui-hall.plist" />
                                <OutlineColor A="255" R="0" G="63" B="198" />
                                <ShadowColor A="255" R="0" G="0" B="0" />
                              </AbstractNodeData>
                              <AbstractNodeData Name="LB_type" ActionTag="2114225895" Tag="625" IconVisible="False" LeftMargin="141.7500" RightMargin="158.2500" TopMargin="4.7000" BottomMargin="4.3000" FontSize="20" LabelText="金众大使" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                                <Size X="80.0000" Y="20.0000" />
                                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                                <Position X="181.7500" Y="14.3000" />
                                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                                <CColor A="255" R="108" G="57" B="29" />
                                <PrePosition X="0.4783" Y="0.4931" />
                                <PreSize X="0.2105" Y="0.6897" />
                                <OutlineColor A="255" R="0" G="0" B="0" />
                                <ShadowColor A="255" R="0" G="0" B="0" />
                              </AbstractNodeData>
                            </Children>
                            <AnchorPoint ScaleX="1.0000" ScaleY="1.0000" />
                            <Position X="380.7501" Y="372.2288" />
                            <Scale ScaleX="1.0000" ScaleY="1.0000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition X="1.0073" Y="1.0060" />
                            <PreSize X="1.0053" Y="0.0784" />
                            <SingleColor A="255" R="150" G="200" B="255" />
                            <FirstColor A="255" R="255" G="255" B="255" />
                            <EndColor A="255" R="150" G="200" B="255" />
                            <ColorVector ScaleX="1.0000" ScaleY="0.0000" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="node_2" ActionTag="1880089662" Tag="626" IconVisible="False" LeftMargin="0.7501" RightMargin="-2.7501" TopMargin="30.2269" BottomMargin="310.7731" ClipAble="False" BackColorAlpha="100" ColorAngle="0.0000" Scale9Width="1" Scale9Height="1" ctype="PanelObjectData">
                            <Size X="380.0000" Y="29.0000" />
                            <Children>
                              <AbstractNodeData Name="BTN_select" ActionTag="-877589924" Tag="627" IconVisible="False" LeftMargin="6.5000" RightMargin="-3.5000" TopMargin="-2.0000" BottomMargin="-3.0000" TouchEnable="True" FontSize="14" Scale9Width="1" Scale9Height="1" OutlineSize="0" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ctype="ButtonObjectData">
                                <Size X="377.0000" Y="34.0000" />
                                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                                <Position X="195.0000" Y="14.0000" />
                                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                                <CColor A="255" R="255" G="255" B="255" />
                                <PrePosition X="0.5132" Y="0.4828" />
                                <PreSize X="0.9921" Y="1.1724" />
                                <TextColor A="255" R="255" G="255" B="255" />
                                <NormalFileData Type="PlistSubImage" Path="gui-texture-null.png" Plist="hall/image/gui-hall.plist" />
                                <OutlineColor A="255" R="0" G="63" B="198" />
                                <ShadowColor A="255" R="0" G="0" B="0" />
                              </AbstractNodeData>
                              <AbstractNodeData Name="LB_type" ActionTag="1521815460" Tag="628" IconVisible="False" LeftMargin="138.7500" RightMargin="161.2500" TopMargin="2.7033" BottomMargin="6.2967" FontSize="20" LabelText="资深董事" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                                <Size X="80.0000" Y="20.0000" />
                                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                                <Position X="178.7500" Y="16.2967" />
                                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                                <CColor A="255" R="108" G="57" B="29" />
                                <PrePosition X="0.4704" Y="0.5620" />
                                <PreSize X="0.2105" Y="0.6897" />
                                <OutlineColor A="255" R="0" G="0" B="0" />
                                <ShadowColor A="255" R="0" G="0" B="0" />
                              </AbstractNodeData>
                            </Children>
                            <AnchorPoint ScaleX="1.0000" ScaleY="1.0000" />
                            <Position X="380.7501" Y="339.7731" />
                            <Scale ScaleX="1.0000" ScaleY="1.0000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition X="1.0073" Y="0.9183" />
                            <PreSize X="1.0053" Y="0.0784" />
                            <SingleColor A="255" R="150" G="200" B="255" />
                            <FirstColor A="255" R="255" G="255" B="255" />
                            <EndColor A="255" R="150" G="200" B="255" />
                            <ColorVector ScaleX="1.0000" ScaleY="0.0000" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="node_3" ActionTag="-1491558574" Tag="629" IconVisible="False" LeftMargin="0.7501" RightMargin="-2.7501" TopMargin="62.6826" BottomMargin="278.3174" ClipAble="False" BackColorAlpha="100" ColorAngle="0.0000" Scale9Width="1" Scale9Height="1" ctype="PanelObjectData">
                            <Size X="380.0000" Y="29.0000" />
                            <Children>
                              <AbstractNodeData Name="BTN_select" ActionTag="1193218744" Tag="630" IconVisible="False" LeftMargin="6.5000" RightMargin="-3.5000" TopMargin="-2.0000" BottomMargin="-3.0000" TouchEnable="True" FontSize="14" Scale9Width="1" Scale9Height="1" OutlineSize="0" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ctype="ButtonObjectData">
                                <Size X="377.0000" Y="34.0000" />
                                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                                <Position X="195.0000" Y="14.0000" />
                                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                                <CColor A="255" R="255" G="255" B="255" />
                                <PrePosition X="0.5132" Y="0.4828" />
                                <PreSize X="0.9921" Y="1.1724" />
                                <TextColor A="255" R="255" G="255" B="255" />
                                <NormalFileData Type="PlistSubImage" Path="gui-texture-null.png" Plist="hall/image/gui-hall.plist" />
                                <OutlineColor A="255" R="0" G="63" B="198" />
                                <ShadowColor A="255" R="0" G="0" B="0" />
                              </AbstractNodeData>
                              <AbstractNodeData Name="LB_type" ActionTag="1071300619" Tag="631" IconVisible="False" LeftMargin="139.3000" RightMargin="160.7000" TopMargin="2.7024" BottomMargin="6.2976" FontSize="20" LabelText="高级董事" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                                <Size X="80.0000" Y="20.0000" />
                                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                                <Position X="179.3000" Y="16.2976" />
                                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                                <CColor A="255" R="108" G="57" B="29" />
                                <PrePosition X="0.4718" Y="0.5620" />
                                <PreSize X="0.2105" Y="0.6897" />
                                <OutlineColor A="255" R="0" G="0" B="0" />
                                <ShadowColor A="255" R="0" G="0" B="0" />
                              </AbstractNodeData>
                            </Children>
                            <AnchorPoint ScaleX="1.0000" ScaleY="1.0000" />
                            <Position X="380.7501" Y="307.3174" />
                            <Scale ScaleX="1.0000" ScaleY="1.0000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition X="1.0073" Y="0.8306" />
                            <PreSize X="1.0053" Y="0.0784" />
                            <SingleColor A="255" R="150" G="200" B="255" />
                            <FirstColor A="255" R="255" G="255" B="255" />
                            <EndColor A="255" R="150" G="200" B="255" />
                            <ColorVector ScaleX="1.0000" ScaleY="0.0000" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="node_4" ActionTag="1390063883" Tag="632" IconVisible="False" LeftMargin="0.7501" RightMargin="-2.7501" TopMargin="95.1380" BottomMargin="245.8620" ClipAble="False" BackColorAlpha="100" ColorAngle="0.0000" Scale9Width="1" Scale9Height="1" ctype="PanelObjectData">
                            <Size X="380.0000" Y="29.0000" />
                            <Children>
                              <AbstractNodeData Name="BTN_select" ActionTag="-1304167262" Tag="633" IconVisible="False" LeftMargin="6.5000" RightMargin="-3.5000" TopMargin="-2.0000" BottomMargin="-3.0000" TouchEnable="True" FontSize="14" Scale9Width="1" Scale9Height="1" OutlineSize="0" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ctype="ButtonObjectData">
                                <Size X="377.0000" Y="34.0000" />
                                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                                <Position X="195.0000" Y="14.0000" />
                                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                                <CColor A="255" R="255" G="255" B="255" />
                                <PrePosition X="0.5132" Y="0.4828" />
                                <PreSize X="0.9921" Y="1.1724" />
                                <TextColor A="255" R="255" G="255" B="255" />
                                <NormalFileData Type="PlistSubImage" Path="gui-texture-null.png" Plist="hall/image/gui-hall.plist" />
                                <OutlineColor A="255" R="0" G="63" B="198" />
                                <ShadowColor A="255" R="0" G="0" B="0" />
                              </AbstractNodeData>
                              <AbstractNodeData Name="LB_type" ActionTag="-855631792" Tag="634" IconVisible="False" LeftMargin="161.7500" RightMargin="178.2500" TopMargin="2.7014" BottomMargin="6.2986" FontSize="20" LabelText="董事" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                                <Size X="40.0000" Y="20.0000" />
                                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                                <Position X="181.7500" Y="16.2986" />
                                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                                <CColor A="255" R="108" G="57" B="29" />
                                <PrePosition X="0.4783" Y="0.5620" />
                                <PreSize X="0.1053" Y="0.6897" />
                                <OutlineColor A="255" R="0" G="0" B="0" />
                                <ShadowColor A="255" R="0" G="0" B="0" />
                              </AbstractNodeData>
                            </Children>
                            <AnchorPoint ScaleX="1.0000" ScaleY="1.0000" />
                            <Position X="380.7501" Y="274.8620" />
                            <Scale ScaleX="1.0000" ScaleY="1.0000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition X="1.0073" Y="0.7429" />
                            <PreSize X="1.0053" Y="0.0784" />
                            <SingleColor A="255" R="150" G="200" B="255" />
                            <FirstColor A="255" R="255" G="255" B="255" />
                            <EndColor A="255" R="150" G="200" B="255" />
                            <ColorVector ScaleX="1.0000" ScaleY="0.0000" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="node_5" ActionTag="1199926170" Tag="635" IconVisible="False" LeftMargin="0.7501" RightMargin="-2.7501" TopMargin="127.5939" BottomMargin="213.4061" ClipAble="False" BackColorAlpha="100" ColorAngle="0.0000" Scale9Width="1" Scale9Height="1" ctype="PanelObjectData">
                            <Size X="380.0000" Y="29.0000" />
                            <Children>
                              <AbstractNodeData Name="BTN_select" ActionTag="346195507" Tag="636" IconVisible="False" LeftMargin="6.5000" RightMargin="-3.5000" TopMargin="-2.0000" BottomMargin="-3.0000" TouchEnable="True" FontSize="14" Scale9Width="1" Scale9Height="1" OutlineSize="0" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ctype="ButtonObjectData">
                                <Size X="377.0000" Y="34.0000" />
                                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                                <Position X="195.0000" Y="14.0000" />
                                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                                <CColor A="255" R="255" G="255" B="255" />
                                <PrePosition X="0.5132" Y="0.4828" />
                                <PreSize X="0.9921" Y="1.1724" />
                                <TextColor A="255" R="255" G="255" B="255" />
                                <NormalFileData Type="PlistSubImage" Path="gui-texture-null.png" Plist="hall/image/gui-hall.plist" />
                                <OutlineColor A="255" R="0" G="63" B="198" />
                                <ShadowColor A="255" R="0" G="0" B="0" />
                              </AbstractNodeData>
                              <AbstractNodeData Name="LB_type" ActionTag="-437924434" Tag="637" IconVisible="False" LeftMargin="140.7500" RightMargin="159.2500" TopMargin="3.7000" BottomMargin="5.3000" FontSize="20" LabelText="资深总监" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                                <Size X="80.0000" Y="20.0000" />
                                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                                <Position X="180.7500" Y="15.3000" />
                                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                                <CColor A="255" R="108" G="57" B="29" />
                                <PrePosition X="0.4757" Y="0.5276" />
                                <PreSize X="0.2105" Y="0.6897" />
                                <OutlineColor A="255" R="0" G="0" B="0" />
                                <ShadowColor A="255" R="0" G="0" B="0" />
                              </AbstractNodeData>
                            </Children>
                            <AnchorPoint ScaleX="1.0000" ScaleY="1.0000" />
                            <Position X="380.7501" Y="242.4061" />
                            <Scale ScaleX="1.0000" ScaleY="1.0000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition X="1.0073" Y="0.6552" />
                            <PreSize X="1.0053" Y="0.0784" />
                            <SingleColor A="255" R="150" G="200" B="255" />
                            <FirstColor A="255" R="255" G="255" B="255" />
                            <EndColor A="255" R="150" G="200" B="255" />
                            <ColorVector ScaleX="1.0000" ScaleY="0.0000" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="node_6" ActionTag="-289767804" Tag="638" IconVisible="False" LeftMargin="0.7501" RightMargin="-2.7501" TopMargin="160.0500" BottomMargin="180.9500" ClipAble="False" BackColorAlpha="100" ColorAngle="0.0000" Scale9Width="1" Scale9Height="1" ctype="PanelObjectData">
                            <Size X="380.0000" Y="29.0000" />
                            <Children>
                              <AbstractNodeData Name="BTN_select" ActionTag="-1952019576" Tag="639" IconVisible="False" LeftMargin="6.5000" RightMargin="-3.5000" TopMargin="-2.0000" BottomMargin="-3.0000" TouchEnable="True" FontSize="14" Scale9Width="1" Scale9Height="1" OutlineSize="0" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ctype="ButtonObjectData">
                                <Size X="377.0000" Y="34.0000" />
                                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                                <Position X="195.0000" Y="14.0000" />
                                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                                <CColor A="255" R="255" G="255" B="255" />
                                <PrePosition X="0.5132" Y="0.4828" />
                                <PreSize X="0.9921" Y="1.1724" />
                                <TextColor A="255" R="255" G="255" B="255" />
                                <NormalFileData Type="PlistSubImage" Path="gui-texture-null.png" Plist="hall/image/gui-hall.plist" />
                                <OutlineColor A="255" R="0" G="63" B="198" />
                                <ShadowColor A="255" R="0" G="0" B="0" />
                              </AbstractNodeData>
                              <AbstractNodeData Name="LB_type" ActionTag="-252501532" Tag="640" IconVisible="False" LeftMargin="141.1000" RightMargin="158.9000" TopMargin="2.6993" BottomMargin="6.3007" FontSize="20" LabelText="高级总监" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                                <Size X="80.0000" Y="20.0000" />
                                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                                <Position X="181.1000" Y="16.3007" />
                                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                                <CColor A="255" R="108" G="57" B="29" />
                                <PrePosition X="0.4766" Y="0.5621" />
                                <PreSize X="0.2105" Y="0.6897" />
                                <OutlineColor A="255" R="0" G="0" B="0" />
                                <ShadowColor A="255" R="0" G="0" B="0" />
                              </AbstractNodeData>
                            </Children>
                            <AnchorPoint ScaleX="1.0000" ScaleY="1.0000" />
                            <Position X="380.7501" Y="209.9500" />
                            <Scale ScaleX="1.0000" ScaleY="1.0000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition X="1.0073" Y="0.5674" />
                            <PreSize X="1.0053" Y="0.0784" />
                            <SingleColor A="255" R="150" G="200" B="255" />
                            <FirstColor A="255" R="255" G="255" B="255" />
                            <EndColor A="255" R="150" G="200" B="255" />
                            <ColorVector ScaleX="1.0000" ScaleY="0.0000" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="node_7" ActionTag="247050509" Tag="641" IconVisible="False" LeftMargin="0.7501" RightMargin="-2.7501" TopMargin="192.5053" BottomMargin="148.4947" ClipAble="False" BackColorAlpha="100" ColorAngle="0.0000" Scale9Width="1" Scale9Height="1" ctype="PanelObjectData">
                            <Size X="380.0000" Y="29.0000" />
                            <Children>
                              <AbstractNodeData Name="BTN_select" ActionTag="1305004139" Tag="642" IconVisible="False" LeftMargin="6.5000" RightMargin="-3.5000" TopMargin="-2.0000" BottomMargin="-3.0000" TouchEnable="True" FontSize="14" Scale9Width="1" Scale9Height="1" OutlineSize="0" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ctype="ButtonObjectData">
                                <Size X="377.0000" Y="34.0000" />
                                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                                <Position X="195.0000" Y="14.0000" />
                                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                                <CColor A="255" R="255" G="255" B="255" />
                                <PrePosition X="0.5132" Y="0.4828" />
                                <PreSize X="0.9921" Y="1.1724" />
                                <TextColor A="255" R="255" G="255" B="255" />
                                <NormalFileData Type="PlistSubImage" Path="gui-texture-null.png" Plist="hall/image/gui-hall.plist" />
                                <OutlineColor A="255" R="0" G="63" B="198" />
                                <ShadowColor A="255" R="0" G="0" B="0" />
                              </AbstractNodeData>
                              <AbstractNodeData Name="LB_type" ActionTag="574005096" Tag="643" IconVisible="False" LeftMargin="160.7500" RightMargin="179.2500" TopMargin="2.7038" BottomMargin="6.2962" FontSize="20" LabelText="总监" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                                <Size X="40.0000" Y="20.0000" />
                                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                                <Position X="180.7500" Y="16.2962" />
                                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                                <CColor A="255" R="108" G="57" B="29" />
                                <PrePosition X="0.4757" Y="0.5619" />
                                <PreSize X="0.1053" Y="0.6897" />
                                <OutlineColor A="255" R="0" G="0" B="0" />
                                <ShadowColor A="255" R="0" G="0" B="0" />
                              </AbstractNodeData>
                            </Children>
                            <AnchorPoint ScaleX="1.0000" ScaleY="1.0000" />
                            <Position X="380.7501" Y="177.4947" />
                            <Scale ScaleX="1.0000" ScaleY="1.0000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition X="1.0073" Y="0.4797" />
                            <PreSize X="1.0053" Y="0.0784" />
                            <SingleColor A="255" R="150" G="200" B="255" />
                            <FirstColor A="255" R="255" G="255" B="255" />
                            <EndColor A="255" R="150" G="200" B="255" />
                            <ColorVector ScaleX="1.0000" ScaleY="0.0000" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="node_8" ActionTag="-554072835" Tag="644" IconVisible="False" LeftMargin="0.7501" RightMargin="-2.7501" TopMargin="224.9613" BottomMargin="116.0387" ClipAble="False" BackColorAlpha="100" ColorAngle="0.0000" Scale9Width="1" Scale9Height="1" ctype="PanelObjectData">
                            <Size X="380.0000" Y="29.0000" />
                            <Children>
                              <AbstractNodeData Name="BTN_select" ActionTag="635146270" Tag="645" IconVisible="False" LeftMargin="6.5000" RightMargin="-3.5000" TopMargin="-2.0000" BottomMargin="-3.0000" TouchEnable="True" FontSize="14" Scale9Width="1" Scale9Height="1" OutlineSize="0" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ctype="ButtonObjectData">
                                <Size X="377.0000" Y="34.0000" />
                                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                                <Position X="195.0000" Y="14.0000" />
                                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                                <CColor A="255" R="255" G="255" B="255" />
                                <PrePosition X="0.5132" Y="0.4828" />
                                <PreSize X="0.9921" Y="1.1724" />
                                <TextColor A="255" R="255" G="255" B="255" />
                                <NormalFileData Type="PlistSubImage" Path="gui-texture-null.png" Plist="hall/image/gui-hall.plist" />
                                <OutlineColor A="255" R="0" G="63" B="198" />
                                <ShadowColor A="255" R="0" G="0" B="0" />
                              </AbstractNodeData>
                              <AbstractNodeData Name="LB_type" ActionTag="-1214511179" Tag="646" IconVisible="False" LeftMargin="141.1000" RightMargin="158.9000" TopMargin="1.9100" BottomMargin="7.0900" FontSize="20" LabelText="高级经理" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                                <Size X="80.0000" Y="20.0000" />
                                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                                <Position X="181.1000" Y="17.0900" />
                                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                                <CColor A="255" R="108" G="57" B="29" />
                                <PrePosition X="0.4766" Y="0.5893" />
                                <PreSize X="0.2105" Y="0.6897" />
                                <OutlineColor A="255" R="0" G="0" B="0" />
                                <ShadowColor A="255" R="0" G="0" B="0" />
                              </AbstractNodeData>
                            </Children>
                            <AnchorPoint ScaleX="1.0000" ScaleY="1.0000" />
                            <Position X="380.7501" Y="145.0387" />
                            <Scale ScaleX="1.0000" ScaleY="1.0000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition X="1.0073" Y="0.3920" />
                            <PreSize X="1.0053" Y="0.0784" />
                            <SingleColor A="255" R="150" G="200" B="255" />
                            <FirstColor A="255" R="255" G="255" B="255" />
                            <EndColor A="255" R="150" G="200" B="255" />
                            <ColorVector ScaleX="1.0000" ScaleY="0.0000" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="node_9" ActionTag="-921839194" Tag="647" IconVisible="False" LeftMargin="0.7501" RightMargin="-2.7501" TopMargin="257.4173" BottomMargin="83.5827" ClipAble="False" BackColorAlpha="100" ColorAngle="0.0000" Scale9Width="1" Scale9Height="1" ctype="PanelObjectData">
                            <Size X="380.0000" Y="29.0000" />
                            <Children>
                              <AbstractNodeData Name="BTN_select" ActionTag="-464593536" Tag="648" IconVisible="False" LeftMargin="6.5000" RightMargin="-3.5000" TopMargin="-2.0000" BottomMargin="-3.0000" TouchEnable="True" FontSize="14" Scale9Width="1" Scale9Height="1" OutlineSize="0" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ctype="ButtonObjectData">
                                <Size X="377.0000" Y="34.0000" />
                                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                                <Position X="195.0000" Y="14.0000" />
                                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                                <CColor A="255" R="255" G="255" B="255" />
                                <PrePosition X="0.5132" Y="0.4828" />
                                <PreSize X="0.9921" Y="1.1724" />
                                <TextColor A="255" R="255" G="255" B="255" />
                                <NormalFileData Type="PlistSubImage" Path="gui-texture-null.png" Plist="hall/image/gui-hall.plist" />
                                <OutlineColor A="255" R="0" G="63" B="198" />
                                <ShadowColor A="255" R="0" G="0" B="0" />
                              </AbstractNodeData>
                              <AbstractNodeData Name="LB_type" ActionTag="1347271643" Tag="649" IconVisible="False" LeftMargin="158.7500" RightMargin="181.2500" TopMargin="2.7032" BottomMargin="6.2968" FontSize="20" LabelText="经理" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                                <Size X="40.0000" Y="20.0000" />
                                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                                <Position X="178.7500" Y="16.2968" />
                                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                                <CColor A="255" R="108" G="57" B="29" />
                                <PrePosition X="0.4704" Y="0.5620" />
                                <PreSize X="0.1053" Y="0.6897" />
                                <OutlineColor A="255" R="0" G="0" B="0" />
                                <ShadowColor A="255" R="0" G="0" B="0" />
                              </AbstractNodeData>
                            </Children>
                            <AnchorPoint ScaleX="1.0000" ScaleY="1.0000" />
                            <Position X="380.7501" Y="112.5827" />
                            <Scale ScaleX="1.0000" ScaleY="1.0000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition X="1.0073" Y="0.3043" />
                            <PreSize X="1.0053" Y="0.0784" />
                            <SingleColor A="255" R="150" G="200" B="255" />
                            <FirstColor A="255" R="255" G="255" B="255" />
                            <EndColor A="255" R="150" G="200" B="255" />
                            <ColorVector ScaleX="1.0000" ScaleY="0.0000" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="node_10" ActionTag="-793012589" Tag="650" IconVisible="False" LeftMargin="0.7501" RightMargin="-2.7501" TopMargin="289.8731" BottomMargin="51.1269" ClipAble="False" BackColorAlpha="100" ColorAngle="0.0000" Scale9Width="1" Scale9Height="1" ctype="PanelObjectData">
                            <Size X="380.0000" Y="29.0000" />
                            <Children>
                              <AbstractNodeData Name="BTN_select" ActionTag="-205331308" Tag="651" IconVisible="False" LeftMargin="6.5000" RightMargin="-3.5000" TopMargin="-2.0000" BottomMargin="-3.0000" TouchEnable="True" FontSize="14" Scale9Width="1" Scale9Height="1" OutlineSize="0" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ctype="ButtonObjectData">
                                <Size X="377.0000" Y="34.0000" />
                                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                                <Position X="195.0000" Y="14.0000" />
                                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                                <CColor A="255" R="255" G="255" B="255" />
                                <PrePosition X="0.5132" Y="0.4828" />
                                <PreSize X="0.9921" Y="1.1724" />
                                <TextColor A="255" R="255" G="255" B="255" />
                                <NormalFileData Type="PlistSubImage" Path="gui-texture-null.png" Plist="hall/image/gui-hall.plist" />
                                <OutlineColor A="255" R="0" G="63" B="198" />
                                <ShadowColor A="255" R="0" G="0" B="0" />
                              </AbstractNodeData>
                              <AbstractNodeData Name="LB_type" ActionTag="651882943" Tag="652" IconVisible="False" LeftMargin="140.8900" RightMargin="159.1100" TopMargin="-1.4893" BottomMargin="10.4893" FontSize="20" LabelText="高级主任" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                                <Size X="80.0000" Y="20.0000" />
                                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                                <Position X="180.8900" Y="20.4893" />
                                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                                <CColor A="255" R="108" G="57" B="29" />
                                <PrePosition X="0.4760" Y="0.7065" />
                                <PreSize X="0.2105" Y="0.6897" />
                                <OutlineColor A="255" R="0" G="0" B="0" />
                                <ShadowColor A="255" R="0" G="0" B="0" />
                              </AbstractNodeData>
                            </Children>
                            <AnchorPoint ScaleX="1.0000" ScaleY="1.0000" />
                            <Position X="380.7501" Y="80.1269" />
                            <Scale ScaleX="1.0000" ScaleY="1.0000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition X="1.0073" Y="0.2166" />
                            <PreSize X="1.0053" Y="0.0784" />
                            <SingleColor A="255" R="150" G="200" B="255" />
                            <FirstColor A="255" R="255" G="255" B="255" />
                            <EndColor A="255" R="150" G="200" B="255" />
                            <ColorVector ScaleX="1.0000" ScaleY="0.0000" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="node_11" ActionTag="1884716005" Tag="653" IconVisible="False" LeftMargin="0.7501" RightMargin="-2.7501" TopMargin="322.3287" BottomMargin="18.6713" ClipAble="False" BackColorAlpha="100" ColorAngle="0.0000" LeftEage="50" RightEage="50" TopEage="16" BottomEage="16" Scale9OriginX="-50" Scale9OriginY="-16" Scale9Width="100" Scale9Height="32" ctype="PanelObjectData">
                            <Size X="380.0000" Y="29.0000" />
                            <Children>
                              <AbstractNodeData Name="BTN_select" ActionTag="1050649582" Tag="654" IconVisible="False" LeftMargin="6.5000" RightMargin="-3.5000" TopMargin="-2.0000" BottomMargin="-3.0000" TouchEnable="True" FontSize="14" Scale9Width="1" Scale9Height="1" OutlineSize="0" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ctype="ButtonObjectData">
                                <Size X="377.0000" Y="34.0000" />
                                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                                <Position X="195.0000" Y="14.0000" />
                                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                                <CColor A="255" R="255" G="255" B="255" />
                                <PrePosition X="0.5132" Y="0.4828" />
                                <PreSize X="0.9921" Y="1.1724" />
                                <TextColor A="255" R="255" G="255" B="255" />
                                <NormalFileData Type="PlistSubImage" Path="gui-texture-null.png" Plist="hall/image/gui-hall.plist" />
                                <OutlineColor A="255" R="0" G="63" B="198" />
                                <ShadowColor A="255" R="0" G="0" B="0" />
                              </AbstractNodeData>
                              <AbstractNodeData Name="LB_type" ActionTag="1798269660" Tag="655" IconVisible="False" LeftMargin="161.0234" RightMargin="178.9766" TopMargin="0.6809" BottomMargin="8.3191" FontSize="20" LabelText="主任" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                                <Size X="40.0000" Y="20.0000" />
                                <AnchorPoint ScaleY="0.5000" />
                                <Position X="161.0234" Y="18.3191" />
                                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                                <CColor A="255" R="108" G="57" B="29" />
                                <PrePosition X="0.4237" Y="0.6317" />
                                <PreSize X="0.1053" Y="0.6897" />
                                <OutlineColor A="255" R="0" G="0" B="0" />
                                <ShadowColor A="255" R="0" G="0" B="0" />
                              </AbstractNodeData>
                            </Children>
                            <AnchorPoint ScaleX="1.0000" ScaleY="1.0000" />
                            <Position X="380.7501" Y="47.6713" />
                            <Scale ScaleX="1.0000" ScaleY="1.0000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition X="1.0073" Y="0.1288" />
                            <PreSize X="1.0053" Y="0.0784" />
                            <SingleColor A="255" R="150" G="200" B="255" />
                            <FirstColor A="255" R="255" G="255" B="255" />
                            <EndColor A="255" R="150" G="200" B="255" />
                            <ColorVector ScaleX="1.0000" ScaleY="0.0000" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="node_12" ActionTag="1065009730" Tag="656" IconVisible="False" LeftMargin="0.5400" RightMargin="-2.5400" TopMargin="354.4694" BottomMargin="-13.4694" ClipAble="False" BackColorAlpha="100" ColorAngle="0.0000" LeftEage="50" RightEage="50" TopEage="16" BottomEage="16" Scale9OriginX="-50" Scale9OriginY="-16" Scale9Width="100" Scale9Height="32" ctype="PanelObjectData">
                            <Size X="380.0000" Y="29.0000" />
                            <Children>
                              <AbstractNodeData Name="BTN_select" ActionTag="936111400" Tag="657" IconVisible="False" LeftMargin="6.5000" RightMargin="-3.5000" TopMargin="-2.0000" BottomMargin="-3.0000" TouchEnable="True" FontSize="14" Scale9Width="1" Scale9Height="1" OutlineSize="0" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ctype="ButtonObjectData">
                                <Size X="377.0000" Y="34.0000" />
                                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                                <Position X="195.0000" Y="14.0000" />
                                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                                <CColor A="255" R="255" G="255" B="255" />
                                <PrePosition X="0.5132" Y="0.4828" />
                                <PreSize X="0.9921" Y="1.1724" />
                                <TextColor A="255" R="255" G="255" B="255" />
                                <NormalFileData Type="PlistSubImage" Path="gui-texture-null.png" Plist="hall/image/gui-hall.plist" />
                                <OutlineColor A="255" R="0" G="63" B="198" />
                                <ShadowColor A="255" R="0" G="0" B="0" />
                              </AbstractNodeData>
                              <AbstractNodeData Name="LB_type" ActionTag="1762227641" Tag="658" IconVisible="False" LeftMargin="161.0234" RightMargin="178.9766" TopMargin="0.6809" BottomMargin="8.3191" FontSize="20" LabelText="助理" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                                <Size X="40.0000" Y="20.0000" />
                                <AnchorPoint ScaleY="0.5000" />
                                <Position X="161.0234" Y="18.3191" />
                                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                                <CColor A="255" R="108" G="57" B="29" />
                                <PrePosition X="0.4237" Y="0.6317" />
                                <PreSize X="0.1053" Y="0.6897" />
                                <OutlineColor A="255" R="0" G="0" B="0" />
                                <ShadowColor A="255" R="0" G="0" B="0" />
                              </AbstractNodeData>
                            </Children>
                            <AnchorPoint ScaleX="1.0000" ScaleY="1.0000" />
                            <Position X="380.5400" Y="15.5306" />
                            <Scale ScaleX="1.0000" ScaleY="1.0000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition X="1.0067" Y="0.0420" />
                            <PreSize X="1.0053" Y="0.0784" />
                            <SingleColor A="255" R="150" G="200" B="255" />
                            <FirstColor A="255" R="255" G="255" B="255" />
                            <EndColor A="255" R="150" G="200" B="255" />
                            <ColorVector ScaleX="1.0000" ScaleY="0.0000" />
                          </AbstractNodeData>
                        </Children>
                        <AnchorPoint ScaleX="0.5000" ScaleY="1.0000" />
                        <Position X="403.6800" Y="323.5200" />
                        <Scale ScaleX="1.0000" ScaleY="0.0001" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <SingleColor A="255" R="150" G="200" B="255" />
                        <FirstColor A="255" R="255" G="255" B="255" />
                        <EndColor A="255" R="150" G="200" B="255" />
                        <ColorVector ScaleX="1.0000" ScaleY="0.0000" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="IMG_TypeBg" ActionTag="-878514974" Tag="659" IconVisible="False" LeftMargin="214.6361" RightMargin="-592.6361" TopMargin="-375.9307" BottomMargin="322.9307" Scale9Enable="True" LeftEage="8" RightEage="8" TopEage="7" BottomEage="7" Scale9OriginX="8" Scale9OriginY="7" Scale9Width="9" Scale9Height="9" ctype="ImageViewObjectData">
                        <Size X="378.0000" Y="53.0000" />
                        <Children>
                          <AbstractNodeData Name="BTN_push" ActionTag="-2033439739" Tag="660" IconVisible="False" LeftMargin="323.4071" RightMargin="16.5929" TopMargin="14.7614" BottomMargin="14.2386" TouchEnable="True" FontSize="14" LeftEage="12" RightEage="12" TopEage="7" BottomEage="7" Scale9OriginX="12" Scale9OriginY="7" Scale9Width="14" Scale9Height="10" OutlineSize="0" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ctype="ButtonObjectData">
                            <Size X="38.0000" Y="24.0000" />
                            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                            <Position X="342.4071" Y="26.2386" />
                            <Scale ScaleX="1.6300" ScaleY="1.6300" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition X="0.9058" Y="0.4951" />
                            <PreSize X="0.1005" Y="0.4528" />
                            <TextColor A="255" R="255" G="255" B="255" />
                            <NormalFileData Type="PlistSubImage" Path="xhan1.png" Plist="hall/plist/gui-agentpop.plist" />
                            <OutlineColor A="255" R="0" G="63" B="198" />
                            <ShadowColor A="255" R="0" G="0" B="0" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="BTN_pull" ActionTag="-2130932675" Tag="661" IconVisible="False" LeftMargin="323.4071" RightMargin="16.5929" TopMargin="14.7614" BottomMargin="14.2386" TouchEnable="True" FontSize="14" LeftEage="12" RightEage="12" TopEage="7" BottomEage="7" Scale9OriginX="12" Scale9OriginY="7" Scale9Width="14" Scale9Height="10" OutlineSize="0" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ctype="ButtonObjectData">
                            <Size X="38.0000" Y="24.0000" />
                            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                            <Position X="342.4071" Y="26.2386" />
                            <Scale ScaleX="1.6300" ScaleY="1.6300" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition X="0.9058" Y="0.4951" />
                            <PreSize X="0.1005" Y="0.4528" />
                            <TextColor A="255" R="255" G="255" B="255" />
                            <NormalFileData Type="PlistSubImage" Path="xhan2.png" Plist="hall/plist/gui-agentpop.plist" />
                            <OutlineColor A="255" R="0" G="63" B="198" />
                            <ShadowColor A="255" R="0" G="0" B="0" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="LB_selectType" ActionTag="373294384" Tag="662" IconVisible="False" LeftMargin="134.1100" RightMargin="143.8900" TopMargin="15.1428" BottomMargin="12.8572" FontSize="25" LabelText="金众大使" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                            <Size X="100.0000" Y="25.0000" />
                            <AnchorPoint ScaleY="0.5000" />
                            <Position X="134.1100" Y="25.3572" />
                            <Scale ScaleX="1.0000" ScaleY="1.0000" />
                            <CColor A="255" R="108" G="58" B="29" />
                            <PrePosition X="0.3548" Y="0.4784" />
                            <PreSize X="0.2646" Y="0.4717" />
                            <OutlineColor A="255" R="0" G="0" B="0" />
                            <ShadowColor A="255" R="0" G="0" B="0" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="BTN_select" ActionTag="-1489165311" Tag="663" IconVisible="False" LeftMargin="27.2620" RightMargin="30.7380" TopMargin="5.5240" BottomMargin="7.4760" TouchEnable="True" FontSize="14" Scale9Width="1" Scale9Height="1" OutlineSize="0" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ctype="ButtonObjectData">
                            <Size X="320.0000" Y="40.0000" />
                            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                            <Position X="187.2620" Y="27.4760" />
                            <Scale ScaleX="1.1900" ScaleY="1.2500" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition X="0.4954" Y="0.5184" />
                            <PreSize X="0.8466" Y="0.7547" />
                            <TextColor A="255" R="255" G="255" B="255" />
                            <NormalFileData Type="PlistSubImage" Path="gui-texture-null.png" Plist="hall/image/gui-hall.plist" />
                            <OutlineColor A="255" R="0" G="63" B="198" />
                            <ShadowColor A="255" R="0" G="0" B="0" />
                          </AbstractNodeData>
                        </Children>
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="214.6361" Y="349.4307" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="kko.png" Plist="hall/plist/gui-agentpop.plist" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint />
                    <Position X="71.7806" Y="69.2215" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.0962" Y="0.1319" />
                    <PreSize X="0.0000" Y="0.0000" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint />
                <Position X="404.0000" Y="86.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.3028" Y="0.1147" />
                <PreSize X="0.5592" Y="0.7000" />
                <SingleColor A="255" R="150" G="200" B="255" />
                <FirstColor A="255" R="255" G="255" B="255" />
                <EndColor A="255" R="150" G="200" B="255" />
                <ColorVector ScaleX="1.0000" ScaleY="0.0000" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint />
            <Position />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition />
            <PreSize X="1.0000" Y="1.0000" />
            <SingleColor A="255" R="150" G="200" B="255" />
            <FirstColor A="255" R="255" G="255" B="255" />
            <EndColor A="255" R="150" G="200" B="255" />
            <ColorVector ScaleX="1.0000" ScaleY="0.0000" />
          </AbstractNodeData>
        </Children>
      </ObjectData>
    </Content>
  </Content>
</GameFile>