<GameFile>
  <PropertyGroup Name="SpreadMyPlayerView" Type="Layer" ID="8705c8ac-4a1d-4a74-bacf-bbc1250446cf" Version="3.10.0.0" />
  <Content ctype="GameProjectContent">
    <Content>
      <Animation Duration="95" Speed="1.0000" ActivedAnimationName="AnimationSlecet">
        <Timeline ActionTag="1050578556" Property="Position">
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
        <Timeline ActionTag="1050578556" Property="Scale">
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
        <Timeline ActionTag="1050578556" Property="RotationSkew">
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
        <Timeline ActionTag="1050578556" Property="AnchorPoint">
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
        <Timeline ActionTag="1050578556" Property="VisibleForFrame">
          <BoolFrame FrameIndex="70" Tween="False" Value="True" />
          <BoolFrame FrameIndex="95" Tween="False" Value="False" />
        </Timeline>
      </Animation>
      <AnimationList>
        <AnimationInfo Name="AnimationSlecet" StartIndex="70" EndIndex="80">
          <RenderColor A="255" R="255" G="127" B="80" />
        </AnimationInfo>
        <AnimationInfo Name="AnimationUnSlecet" StartIndex="85" EndIndex="95">
          <RenderColor A="255" R="0" G="100" B="0" />
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
                  <AbstractNodeData Name="Button_nextpage" ActionTag="440461887" Tag="951" IconVisible="False" LeftMargin="279.6522" RightMargin="394.3478" TopMargin="497.6949" BottomMargin="1.3051" TouchEnable="True" FontSize="26" ButtonText="下一页" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="4" BottomEage="4" Scale9OriginX="15" Scale9OriginY="4" Scale9Width="48" Scale9Height="18" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                    <Size X="72.0000" Y="26.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="315.6522" Y="14.3051" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.4231" Y="0.0272" />
                    <PreSize X="0.0965" Y="0.0495" />
                    <TextColor A="255" R="108" G="39" B="39" />
                    <DisabledFileData Type="Default" Path="Default/Button_Disable.png" Plist="" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="110" G="110" B="110" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Button_lastpage" ActionTag="-429515650" Tag="952" IconVisible="False" LeftMargin="405.0989" RightMargin="265.9011" TopMargin="497.6240" BottomMargin="-1.6240" TouchEnable="True" FontSize="26" ButtonText="上一页" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="4" BottomEage="4" Scale9OriginX="15" Scale9OriginY="4" Scale9Width="48" Scale9Height="18" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                    <Size X="75.0000" Y="29.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="442.5989" Y="12.8760" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.5933" Y="0.0245" />
                    <PreSize X="0.1005" Y="0.0552" />
                    <TextColor A="255" R="108" G="39" B="39" />
                    <DisabledFileData Type="Default" Path="Default/Button_Disable.png" Plist="" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="110" G="110" B="110" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="bg_imagetext" ActionTag="2106146731" Tag="922" IconVisible="True" RightMargin="746.0000" TopMargin="525.0000" ctype="SingleNodeObjectData">
                    <Size X="0.0000" Y="0.0000" />
                    <Children>
                      <AbstractNodeData Name="Label_1" ActionTag="1891355140" Tag="932" IconVisible="False" LeftMargin="9.4250" RightMargin="-93.4250" TopMargin="-559.5161" BottomMargin="531.5161" FontSize="28" LabelText="用户ID" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="84.0000" Y="28.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="9.4250" Y="545.5161" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="108" G="59" B="27" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <OutlineColor A="255" R="0" G="0" B="0" />
                        <ShadowColor A="255" R="0" G="0" B="0" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Label_1_3" ActionTag="-1368353918" Tag="933" IconVisible="False" LeftMargin="159.2011" RightMargin="-215.2011" TopMargin="-559.5162" BottomMargin="531.5162" FontSize="28" LabelText="昵称" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="56.0000" Y="28.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="159.2011" Y="545.5162" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="108" G="59" B="27" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <OutlineColor A="255" R="0" G="0" B="0" />
                        <ShadowColor A="255" R="0" G="0" B="0" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Label_1_2" ActionTag="832942865" Tag="934" IconVisible="False" LeftMargin="275.4922" RightMargin="-387.4922" TopMargin="-559.0809" BottomMargin="531.0809" FontSize="28" LabelText="加入时间" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="112.0000" Y="28.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="275.4922" Y="545.0809" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="108" G="59" B="27" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <OutlineColor A="255" R="0" G="0" B="0" />
                        <ShadowColor A="255" R="0" G="0" B="0" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Label_1_1" ActionTag="922961748" Tag="935" IconVisible="False" LeftMargin="416.2789" RightMargin="-528.2789" TopMargin="-558.3468" BottomMargin="530.3468" FontSize="28" LabelText="最后登录" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="112.0000" Y="28.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="416.2789" Y="544.3468" />
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
                      <AbstractNodeData Name="Label_1_1_0" ActionTag="1271102938" Tag="949" IconVisible="False" LeftMargin="553.9756" RightMargin="-665.9756" TopMargin="-556.9235" BottomMargin="528.9235" FontSize="28" LabelText="本周贡献" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="112.0000" Y="28.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="553.9756" Y="542.9235" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="108" G="59" B="27" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <OutlineColor A="255" R="0" G="0" B="0" />
                        <ShadowColor A="255" R="0" G="0" B="0" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Label_1_1_1" ActionTag="-1692655116" Tag="950" IconVisible="False" LeftMargin="694.5317" RightMargin="-806.5317" TopMargin="-557.4058" BottomMargin="529.4058" FontSize="28" LabelText="开通代理" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="112.0000" Y="28.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="694.5317" Y="543.4058" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="108" G="59" B="27" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <OutlineColor A="255" R="0" G="0" B="0" />
                        <ShadowColor A="255" R="0" G="0" B="0" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Label_1_1_1_0" ActionTag="-1987008208" Tag="953" IconVisible="False" LeftMargin="362.7199" RightMargin="-390.7199" TopMargin="-26.4136" BottomMargin="-1.5864" FontSize="28" LabelText="—" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="28.0000" Y="28.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="362.7199" Y="12.4136" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="108" G="59" B="27" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <OutlineColor A="255" R="0" G="0" B="0" />
                        <ShadowColor A="255" R="0" G="0" B="0" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint />
                    <Position />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition />
                    <PreSize X="0.0000" Y="0.0000" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="node_item_1" ActionTag="-1188332168" Tag="948" IconVisible="True" LeftMargin="-21.6500" RightMargin="767.6500" TopMargin="34.5394" BottomMargin="490.4606" ctype="SingleNodeObjectData">
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
                      <AbstractNodeData Name="Text_3" ActionTag="-1082313309" Tag="961" IconVisible="False" LeftMargin="283.7416" RightMargin="-422.7416" TopMargin="-27.7941" BottomMargin="-23.2059" IsCustomSize="True" FontSize="18" LabelText="" HorizontalAlignmentType="HT_Center" VerticalAlignmentType="VT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="353.2416" Y="2.2941" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="108" G="59" B="27" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_4" ActionTag="-1823689193" Tag="962" IconVisible="False" LeftMargin="423.0211" RightMargin="-562.0211" TopMargin="-27.7941" BottomMargin="-23.2059" IsCustomSize="True" FontSize="18" LabelText="" HorizontalAlignmentType="HT_Center" VerticalAlignmentType="VT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="139.0000" Y="51.0000" />
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
                      <AbstractNodeData Name="Button_beAgent" ActionTag="-1828456863" Tag="677" IconVisible="False" LeftMargin="693.0000" RightMargin="-847.0000" TopMargin="-29.0000" BottomMargin="-21.0000" TouchEnable="True" FontSize="26" ButtonText="开通代理" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="4" BottomEage="4" Scale9OriginX="15" Scale9OriginY="4" Scale9Width="124" Scale9Height="42" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                        <Size X="154.0000" Y="50.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="770.0000" Y="4.0000" />
                        <Scale ScaleX="0.6400" ScaleY="0.6400" />
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
                    <Position X="-21.6500" Y="490.4606" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="-0.0290" Y="0.9342" />
                    <PreSize X="0.0000" Y="0.0000" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="node_item_2" ActionTag="-235208973" Tag="154" IconVisible="True" LeftMargin="-21.6500" RightMargin="767.6500" TopMargin="83.1827" BottomMargin="441.8173" ctype="SingleNodeObjectData">
                    <Size X="0.0000" Y="0.0000" />
                    <Children>
                      <AbstractNodeData Name="Image_1" ActionTag="210954693" Tag="155" IconVisible="False" LeftMargin="3.3060" RightMargin="-142.3060" TopMargin="-28.2433" BottomMargin="-22.7567" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="63" Scale9Height="59" ctype="ImageViewObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="72.8060" Y="2.7433" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="hall/plist/bj0.png" Plist="hall/plist/promotor.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Image_2" ActionTag="-1309748909" Tag="156" IconVisible="False" LeftMargin="142.4714" RightMargin="-281.4714" TopMargin="-28.2433" BottomMargin="-22.7567" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="63" Scale9Height="59" ctype="ImageViewObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="211.9714" Y="2.7433" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="hall/plist/bj0.png" Plist="hall/plist/promotor.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Image_3" ActionTag="2137910161" Tag="157" IconVisible="False" LeftMargin="281.4407" RightMargin="-420.4407" TopMargin="-28.2433" BottomMargin="-22.7567" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="63" Scale9Height="59" ctype="ImageViewObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="350.9407" Y="2.7433" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="hall/plist/bj0.png" Plist="hall/plist/promotor.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Image_4" ActionTag="-984975292" Tag="158" IconVisible="False" LeftMargin="421.0115" RightMargin="-560.0115" TopMargin="-28.2433" BottomMargin="-22.7567" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="63" Scale9Height="59" ctype="ImageViewObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="490.5115" Y="2.7433" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="hall/plist/bj0.png" Plist="hall/plist/promotor.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Image_5" ActionTag="-715148648" Tag="159" IconVisible="False" LeftMargin="559.5823" RightMargin="-698.5823" TopMargin="-28.2433" BottomMargin="-22.7567" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="63" Scale9Height="59" ctype="ImageViewObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="629.0823" Y="2.7433" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="hall/plist/bj0.png" Plist="hall/plist/promotor.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Image_6" ActionTag="983533720" Tag="160" IconVisible="False" LeftMargin="699.1517" RightMargin="-838.1517" TopMargin="-28.2433" BottomMargin="-22.7567" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="63" Scale9Height="59" ctype="ImageViewObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="768.6517" Y="2.7433" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="hall/plist/bj0.png" Plist="hall/plist/promotor.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_1" ActionTag="464941783" Tag="161" IconVisible="False" LeftMargin="74.6805" RightMargin="-74.6805" TopMargin="-2.2941" BottomMargin="2.2941" FontSize="20" LabelText="" HorizontalAlignmentType="HT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
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
                      <AbstractNodeData Name="Text_2" ActionTag="-537038830" Tag="162" IconVisible="False" LeftMargin="213.9604" RightMargin="-213.9604" TopMargin="-2.2941" BottomMargin="2.2941" FontSize="20" LabelText="" HorizontalAlignmentType="HT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
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
                      <AbstractNodeData Name="Text_3" ActionTag="-1712713518" Tag="163" IconVisible="False" LeftMargin="283.7416" RightMargin="-422.7416" TopMargin="-27.7941" BottomMargin="-23.2059" IsCustomSize="True" FontSize="18" LabelText="" HorizontalAlignmentType="HT_Center" VerticalAlignmentType="VT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="353.2416" Y="2.2941" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="108" G="59" B="27" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_4" ActionTag="205095893" Tag="164" IconVisible="False" LeftMargin="423.0211" RightMargin="-562.0211" TopMargin="-27.7941" BottomMargin="-23.2059" IsCustomSize="True" FontSize="18" LabelText="" HorizontalAlignmentType="HT_Center" VerticalAlignmentType="VT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="492.5211" Y="2.2941" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="108" G="59" B="27" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_5" ActionTag="-560961999" Tag="165" IconVisible="False" LeftMargin="631.8009" RightMargin="-631.8009" TopMargin="-2.2941" BottomMargin="2.2941" FontSize="20" LabelText="" HorizontalAlignmentType="HT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
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
                      <AbstractNodeData Name="Text_6" ActionTag="-2104102810" Tag="166" IconVisible="False" LeftMargin="771.0809" RightMargin="-771.0809" TopMargin="-2.2941" BottomMargin="2.2941" FontSize="20" LabelText="" HorizontalAlignmentType="HT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
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
                      <AbstractNodeData Name="Button_beAgent" ActionTag="-47185232" Tag="678" IconVisible="False" LeftMargin="693.0000" RightMargin="-847.0000" TopMargin="-29.0000" BottomMargin="-21.0000" TouchEnable="True" FontSize="26" ButtonText="开通代理" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="4" BottomEage="4" Scale9OriginX="15" Scale9OriginY="4" Scale9Width="124" Scale9Height="42" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                        <Size X="154.0000" Y="50.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="770.0000" Y="4.0000" />
                        <Scale ScaleX="0.6400" ScaleY="0.6400" />
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
                    <Position X="-21.6500" Y="441.8173" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="-0.0290" Y="0.8416" />
                    <PreSize X="0.0000" Y="0.0000" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="node_item_3" ActionTag="1374940967" Tag="167" IconVisible="True" LeftMargin="-21.6500" RightMargin="767.6500" TopMargin="132.9972" BottomMargin="392.0028" ctype="SingleNodeObjectData">
                    <Size X="0.0000" Y="0.0000" />
                    <Children>
                      <AbstractNodeData Name="Image_1" ActionTag="-1899768624" Tag="168" IconVisible="False" LeftMargin="3.3060" RightMargin="-142.3060" TopMargin="-28.2433" BottomMargin="-22.7567" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="63" Scale9Height="59" ctype="ImageViewObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="72.8060" Y="2.7433" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="hall/plist/bj0.png" Plist="hall/plist/promotor.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Image_2" ActionTag="1672743631" Tag="169" IconVisible="False" LeftMargin="142.4714" RightMargin="-281.4714" TopMargin="-28.2433" BottomMargin="-22.7567" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="63" Scale9Height="59" ctype="ImageViewObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="211.9714" Y="2.7433" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="hall/plist/bj0.png" Plist="hall/plist/promotor.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Image_3" ActionTag="-2001743238" Tag="170" IconVisible="False" LeftMargin="281.4407" RightMargin="-420.4407" TopMargin="-28.2433" BottomMargin="-22.7567" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="63" Scale9Height="59" ctype="ImageViewObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="350.9407" Y="2.7433" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="hall/plist/bj0.png" Plist="hall/plist/promotor.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Image_4" ActionTag="2120872794" Tag="171" IconVisible="False" LeftMargin="421.0115" RightMargin="-560.0115" TopMargin="-28.2433" BottomMargin="-22.7567" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="63" Scale9Height="59" ctype="ImageViewObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="490.5115" Y="2.7433" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="hall/plist/bj0.png" Plist="hall/plist/promotor.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Image_5" ActionTag="677980132" Tag="172" IconVisible="False" LeftMargin="559.5823" RightMargin="-698.5823" TopMargin="-28.2433" BottomMargin="-22.7567" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="63" Scale9Height="59" ctype="ImageViewObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="629.0823" Y="2.7433" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="hall/plist/bj0.png" Plist="hall/plist/promotor.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Image_6" ActionTag="-331513494" Tag="173" IconVisible="False" LeftMargin="699.1517" RightMargin="-838.1517" TopMargin="-28.2433" BottomMargin="-22.7567" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="63" Scale9Height="59" ctype="ImageViewObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="768.6517" Y="2.7433" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="hall/plist/bj0.png" Plist="hall/plist/promotor.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_1" ActionTag="1131945860" Tag="174" IconVisible="False" LeftMargin="74.6805" RightMargin="-74.6805" TopMargin="-2.2941" BottomMargin="2.2941" FontSize="20" LabelText="" HorizontalAlignmentType="HT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
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
                      <AbstractNodeData Name="Text_2" ActionTag="-748346342" Tag="175" IconVisible="False" LeftMargin="213.9604" RightMargin="-213.9604" TopMargin="-2.2941" BottomMargin="2.2941" FontSize="20" LabelText="" HorizontalAlignmentType="HT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
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
                      <AbstractNodeData Name="Text_3" ActionTag="-973782419" Tag="176" IconVisible="False" LeftMargin="283.7416" RightMargin="-422.7416" TopMargin="-27.7941" BottomMargin="-23.2059" IsCustomSize="True" FontSize="18" LabelText="" HorizontalAlignmentType="HT_Center" VerticalAlignmentType="VT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="353.2416" Y="2.2941" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="108" G="59" B="27" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_4" ActionTag="-727658059" Tag="177" IconVisible="False" LeftMargin="423.0211" RightMargin="-562.0211" TopMargin="-27.7941" BottomMargin="-23.2059" IsCustomSize="True" FontSize="18" LabelText="" HorizontalAlignmentType="HT_Center" VerticalAlignmentType="VT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="492.5211" Y="2.2941" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="108" G="59" B="27" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_5" ActionTag="1475459284" Tag="178" IconVisible="False" LeftMargin="631.8009" RightMargin="-631.8009" TopMargin="-2.2941" BottomMargin="2.2941" FontSize="20" LabelText="" HorizontalAlignmentType="HT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
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
                      <AbstractNodeData Name="Text_6" ActionTag="444717015" Tag="179" IconVisible="False" LeftMargin="771.0809" RightMargin="-771.0809" TopMargin="-2.2941" BottomMargin="2.2941" FontSize="20" LabelText="" HorizontalAlignmentType="HT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
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
                      <AbstractNodeData Name="Button_beAgent" ActionTag="2109387506" Tag="679" IconVisible="False" LeftMargin="693.0000" RightMargin="-847.0000" TopMargin="-29.0000" BottomMargin="-21.0000" TouchEnable="True" FontSize="26" ButtonText="开通代理" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="4" BottomEage="4" Scale9OriginX="15" Scale9OriginY="4" Scale9Width="124" Scale9Height="42" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                        <Size X="154.0000" Y="50.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="770.0000" Y="4.0000" />
                        <Scale ScaleX="0.6400" ScaleY="0.6400" />
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
                    <Position X="-21.6500" Y="392.0028" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="-0.0290" Y="0.7467" />
                    <PreSize X="0.0000" Y="0.0000" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="node_item_4" ActionTag="-1217325420" Tag="180" IconVisible="True" LeftMargin="-21.6500" RightMargin="767.6500" TopMargin="182.8123" BottomMargin="342.1877" ctype="SingleNodeObjectData">
                    <Size X="0.0000" Y="0.0000" />
                    <Children>
                      <AbstractNodeData Name="Image_1" ActionTag="-849300454" Tag="181" IconVisible="False" LeftMargin="3.3060" RightMargin="-142.3060" TopMargin="-28.2433" BottomMargin="-22.7567" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="63" Scale9Height="59" ctype="ImageViewObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="72.8060" Y="2.7433" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="hall/plist/bj0.png" Plist="hall/plist/promotor.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Image_2" ActionTag="122728339" Tag="182" IconVisible="False" LeftMargin="142.4714" RightMargin="-281.4714" TopMargin="-28.2433" BottomMargin="-22.7567" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="63" Scale9Height="59" ctype="ImageViewObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="211.9714" Y="2.7433" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="hall/plist/bj0.png" Plist="hall/plist/promotor.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Image_3" ActionTag="-1044941987" Tag="183" IconVisible="False" LeftMargin="281.4407" RightMargin="-420.4407" TopMargin="-28.2433" BottomMargin="-22.7567" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="63" Scale9Height="59" ctype="ImageViewObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="350.9407" Y="2.7433" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="hall/plist/bj0.png" Plist="hall/plist/promotor.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Image_4" ActionTag="-792833182" Tag="184" IconVisible="False" LeftMargin="421.0115" RightMargin="-560.0115" TopMargin="-28.2433" BottomMargin="-22.7567" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="63" Scale9Height="59" ctype="ImageViewObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="490.5115" Y="2.7433" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="hall/plist/bj0.png" Plist="hall/plist/promotor.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Image_5" ActionTag="-1962246232" Tag="185" IconVisible="False" LeftMargin="559.5823" RightMargin="-698.5823" TopMargin="-28.2433" BottomMargin="-22.7567" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="63" Scale9Height="59" ctype="ImageViewObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="629.0823" Y="2.7433" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="hall/plist/bj0.png" Plist="hall/plist/promotor.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Image_6" ActionTag="1119353565" Tag="186" IconVisible="False" LeftMargin="699.1517" RightMargin="-838.1517" TopMargin="-28.2433" BottomMargin="-22.7567" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="63" Scale9Height="59" ctype="ImageViewObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="768.6517" Y="2.7433" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="hall/plist/bj0.png" Plist="hall/plist/promotor.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_1" ActionTag="581477548" Tag="187" IconVisible="False" LeftMargin="74.6805" RightMargin="-74.6805" TopMargin="-2.2941" BottomMargin="2.2941" FontSize="20" LabelText="" HorizontalAlignmentType="HT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
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
                      <AbstractNodeData Name="Text_2" ActionTag="943587255" Tag="188" IconVisible="False" LeftMargin="213.9604" RightMargin="-213.9604" TopMargin="-2.2941" BottomMargin="2.2941" FontSize="20" LabelText="" HorizontalAlignmentType="HT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
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
                      <AbstractNodeData Name="Text_3" ActionTag="-349199667" Tag="189" IconVisible="False" LeftMargin="283.7416" RightMargin="-422.7416" TopMargin="-27.7941" BottomMargin="-23.2059" IsCustomSize="True" FontSize="18" LabelText="" HorizontalAlignmentType="HT_Center" VerticalAlignmentType="VT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="353.2416" Y="2.2941" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="108" G="59" B="27" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_4" ActionTag="1219108174" Tag="190" IconVisible="False" LeftMargin="423.0211" RightMargin="-562.0211" TopMargin="-27.7941" BottomMargin="-23.2059" IsCustomSize="True" FontSize="18" LabelText="" HorizontalAlignmentType="HT_Center" VerticalAlignmentType="VT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="492.5211" Y="2.2941" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="108" G="59" B="27" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_5" ActionTag="-1939574467" Tag="191" IconVisible="False" LeftMargin="631.8009" RightMargin="-631.8009" TopMargin="-2.2941" BottomMargin="2.2941" FontSize="20" LabelText="" HorizontalAlignmentType="HT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
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
                      <AbstractNodeData Name="Text_6" ActionTag="2056666378" Tag="192" IconVisible="False" LeftMargin="771.0809" RightMargin="-771.0809" TopMargin="-2.2941" BottomMargin="2.2941" FontSize="20" LabelText="" HorizontalAlignmentType="HT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
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
                      <AbstractNodeData Name="Button_beAgent" ActionTag="-381495767" Tag="682" IconVisible="False" LeftMargin="693.0000" RightMargin="-847.0000" TopMargin="-29.0000" BottomMargin="-21.0000" TouchEnable="True" FontSize="26" ButtonText="开通代理" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="4" BottomEage="4" Scale9OriginX="15" Scale9OriginY="4" Scale9Width="124" Scale9Height="42" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                        <Size X="154.0000" Y="50.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="770.0000" Y="4.0000" />
                        <Scale ScaleX="0.6400" ScaleY="0.6400" />
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
                    <Position X="-21.6500" Y="342.1877" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="-0.0290" Y="0.6518" />
                    <PreSize X="0.0000" Y="0.0000" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="node_item_5" ActionTag="935359911" Tag="193" IconVisible="True" LeftMargin="-21.6500" RightMargin="767.6500" TopMargin="232.9700" BottomMargin="292.0300" ctype="SingleNodeObjectData">
                    <Size X="0.0000" Y="0.0000" />
                    <Children>
                      <AbstractNodeData Name="Image_1" ActionTag="-1506860811" Tag="194" IconVisible="False" LeftMargin="3.3060" RightMargin="-142.3060" TopMargin="-28.2433" BottomMargin="-22.7567" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="63" Scale9Height="59" ctype="ImageViewObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="72.8060" Y="2.7433" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="hall/plist/bj0.png" Plist="hall/plist/promotor.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Image_2" ActionTag="-357145720" Tag="195" IconVisible="False" LeftMargin="142.4714" RightMargin="-281.4714" TopMargin="-28.2433" BottomMargin="-22.7567" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="63" Scale9Height="59" ctype="ImageViewObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="211.9714" Y="2.7433" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="hall/plist/bj0.png" Plist="hall/plist/promotor.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Image_3" ActionTag="-723005419" Tag="196" IconVisible="False" LeftMargin="281.4407" RightMargin="-420.4407" TopMargin="-28.2433" BottomMargin="-22.7567" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="63" Scale9Height="59" ctype="ImageViewObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="350.9407" Y="2.7433" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="hall/plist/bj0.png" Plist="hall/plist/promotor.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Image_4" ActionTag="676313712" Tag="197" IconVisible="False" LeftMargin="421.0115" RightMargin="-560.0115" TopMargin="-28.2433" BottomMargin="-22.7567" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="63" Scale9Height="59" ctype="ImageViewObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="490.5115" Y="2.7433" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="hall/plist/bj0.png" Plist="hall/plist/promotor.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Image_5" ActionTag="111478900" Tag="198" IconVisible="False" LeftMargin="559.5823" RightMargin="-698.5823" TopMargin="-28.2433" BottomMargin="-22.7567" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="63" Scale9Height="59" ctype="ImageViewObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="629.0823" Y="2.7433" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="hall/plist/bj0.png" Plist="hall/plist/promotor.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Image_6" ActionTag="-2062111781" Tag="199" IconVisible="False" LeftMargin="699.1517" RightMargin="-838.1517" TopMargin="-28.2433" BottomMargin="-22.7567" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="63" Scale9Height="59" ctype="ImageViewObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="768.6517" Y="2.7433" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="hall/plist/bj0.png" Plist="hall/plist/promotor.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_1" ActionTag="-888743858" Tag="200" IconVisible="False" LeftMargin="74.6805" RightMargin="-74.6805" TopMargin="-2.2941" BottomMargin="2.2941" FontSize="20" LabelText="" HorizontalAlignmentType="HT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
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
                      <AbstractNodeData Name="Text_2" ActionTag="-419708262" Tag="201" IconVisible="False" LeftMargin="213.9604" RightMargin="-213.9604" TopMargin="-2.2941" BottomMargin="2.2941" FontSize="20" LabelText="" HorizontalAlignmentType="HT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
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
                      <AbstractNodeData Name="Text_3" ActionTag="-2037009882" Tag="202" IconVisible="False" LeftMargin="283.7416" RightMargin="-422.7416" TopMargin="-27.7941" BottomMargin="-23.2059" IsCustomSize="True" FontSize="18" LabelText="" HorizontalAlignmentType="HT_Center" VerticalAlignmentType="VT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="353.2416" Y="2.2941" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="108" G="59" B="27" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_4" ActionTag="-1000712000" Tag="203" IconVisible="False" LeftMargin="423.0211" RightMargin="-562.0211" TopMargin="-27.7941" BottomMargin="-23.2059" IsCustomSize="True" FontSize="18" LabelText="" HorizontalAlignmentType="HT_Center" VerticalAlignmentType="VT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="492.5211" Y="2.2941" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="108" G="59" B="27" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_5" ActionTag="-75429557" Tag="204" IconVisible="False" LeftMargin="631.8009" RightMargin="-631.8009" TopMargin="-2.2941" BottomMargin="2.2941" FontSize="20" LabelText="" HorizontalAlignmentType="HT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
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
                      <AbstractNodeData Name="Text_6" ActionTag="746677823" Tag="205" IconVisible="False" LeftMargin="771.0809" RightMargin="-771.0809" TopMargin="-2.2941" BottomMargin="2.2941" FontSize="20" LabelText="" HorizontalAlignmentType="HT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
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
                      <AbstractNodeData Name="Button_beAgent" ActionTag="1870366309" Tag="683" IconVisible="False" LeftMargin="693.0000" RightMargin="-847.0000" TopMargin="-29.0000" BottomMargin="-21.0000" TouchEnable="True" FontSize="26" ButtonText="开通代理" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="4" BottomEage="4" Scale9OriginX="15" Scale9OriginY="4" Scale9Width="124" Scale9Height="42" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                        <Size X="154.0000" Y="50.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="770.0000" Y="4.0000" />
                        <Scale ScaleX="0.6400" ScaleY="0.6400" />
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
                    <Position X="-21.6500" Y="292.0300" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="-0.0290" Y="0.5562" />
                    <PreSize X="0.0000" Y="0.0000" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="node_item_6" ActionTag="-144956905" Tag="206" IconVisible="True" LeftMargin="-21.6500" RightMargin="767.6500" TopMargin="282.6100" BottomMargin="242.3900" ctype="SingleNodeObjectData">
                    <Size X="0.0000" Y="0.0000" />
                    <Children>
                      <AbstractNodeData Name="Image_1" ActionTag="754165163" Tag="207" IconVisible="False" LeftMargin="3.3060" RightMargin="-142.3060" TopMargin="-28.2433" BottomMargin="-22.7567" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="63" Scale9Height="59" ctype="ImageViewObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="72.8060" Y="2.7433" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="hall/plist/bj0.png" Plist="hall/plist/promotor.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Image_2" ActionTag="-1212541883" Tag="208" IconVisible="False" LeftMargin="142.4714" RightMargin="-281.4714" TopMargin="-28.2433" BottomMargin="-22.7567" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="63" Scale9Height="59" ctype="ImageViewObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="211.9714" Y="2.7433" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="hall/plist/bj0.png" Plist="hall/plist/promotor.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Image_3" ActionTag="-1126052299" Tag="209" IconVisible="False" LeftMargin="281.4407" RightMargin="-420.4407" TopMargin="-28.2433" BottomMargin="-22.7567" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="63" Scale9Height="59" ctype="ImageViewObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="350.9407" Y="2.7433" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="hall/plist/bj0.png" Plist="hall/plist/promotor.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Image_4" ActionTag="262097161" Tag="210" IconVisible="False" LeftMargin="421.0115" RightMargin="-560.0115" TopMargin="-28.2433" BottomMargin="-22.7567" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="63" Scale9Height="59" ctype="ImageViewObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="490.5115" Y="2.7433" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="hall/plist/bj0.png" Plist="hall/plist/promotor.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Image_5" ActionTag="1564845040" Tag="211" IconVisible="False" LeftMargin="559.5823" RightMargin="-698.5823" TopMargin="-28.2433" BottomMargin="-22.7567" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="63" Scale9Height="59" ctype="ImageViewObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="629.0823" Y="2.7433" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="hall/plist/bj0.png" Plist="hall/plist/promotor.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Image_6" ActionTag="473072734" Tag="212" IconVisible="False" LeftMargin="699.1517" RightMargin="-838.1517" TopMargin="-28.2433" BottomMargin="-22.7567" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="63" Scale9Height="59" ctype="ImageViewObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="768.6517" Y="2.7433" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="hall/plist/bj0.png" Plist="hall/plist/promotor.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_1" ActionTag="1474952190" Tag="213" IconVisible="False" LeftMargin="74.6805" RightMargin="-74.6805" TopMargin="-2.2941" BottomMargin="2.2941" FontSize="20" LabelText="" HorizontalAlignmentType="HT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
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
                      <AbstractNodeData Name="Text_2" ActionTag="-1150413595" Tag="214" IconVisible="False" LeftMargin="213.9604" RightMargin="-213.9604" TopMargin="-2.2941" BottomMargin="2.2941" FontSize="20" LabelText="" HorizontalAlignmentType="HT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
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
                      <AbstractNodeData Name="Text_3" ActionTag="-666301423" Tag="215" IconVisible="False" LeftMargin="283.7416" RightMargin="-422.7416" TopMargin="-27.7941" BottomMargin="-23.2059" IsCustomSize="True" FontSize="18" LabelText="" HorizontalAlignmentType="HT_Center" VerticalAlignmentType="VT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="353.2416" Y="2.2941" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="108" G="59" B="27" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_4" ActionTag="1855027524" Tag="216" IconVisible="False" LeftMargin="423.0211" RightMargin="-562.0211" TopMargin="-27.7941" BottomMargin="-23.2059" IsCustomSize="True" FontSize="18" LabelText="" HorizontalAlignmentType="HT_Center" VerticalAlignmentType="VT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="492.5211" Y="2.2941" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="108" G="59" B="27" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_5" ActionTag="-505107648" Tag="217" IconVisible="False" LeftMargin="631.8009" RightMargin="-631.8009" TopMargin="-2.2941" BottomMargin="2.2941" FontSize="20" LabelText="" HorizontalAlignmentType="HT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
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
                      <AbstractNodeData Name="Text_6" ActionTag="351673326" Tag="218" IconVisible="False" LeftMargin="771.0809" RightMargin="-771.0809" TopMargin="-2.2941" BottomMargin="2.2941" FontSize="20" LabelText="" HorizontalAlignmentType="HT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
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
                      <AbstractNodeData Name="Button_beAgent" ActionTag="-955423365" Tag="681" IconVisible="False" LeftMargin="693.0000" RightMargin="-847.0000" TopMargin="-29.0000" BottomMargin="-21.0000" TouchEnable="True" FontSize="26" ButtonText="开通代理" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="4" BottomEage="4" Scale9OriginX="15" Scale9OriginY="4" Scale9Width="124" Scale9Height="42" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                        <Size X="154.0000" Y="50.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="770.0000" Y="4.0000" />
                        <Scale ScaleX="0.6400" ScaleY="0.6400" />
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
                    <Position X="-21.6500" Y="242.3900" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="-0.0290" Y="0.4617" />
                    <PreSize X="0.0000" Y="0.0000" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="node_item_7" ActionTag="379997697" Tag="219" IconVisible="True" LeftMargin="-21.6500" RightMargin="767.6500" TopMargin="332.6000" BottomMargin="192.4000" ctype="SingleNodeObjectData">
                    <Size X="0.0000" Y="0.0000" />
                    <Children>
                      <AbstractNodeData Name="Image_1" ActionTag="-179813273" Tag="220" IconVisible="False" LeftMargin="3.3060" RightMargin="-142.3060" TopMargin="-28.2433" BottomMargin="-22.7567" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="63" Scale9Height="59" ctype="ImageViewObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="72.8060" Y="2.7433" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="hall/plist/bj0.png" Plist="hall/plist/promotor.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Image_2" ActionTag="-246052802" Tag="221" IconVisible="False" LeftMargin="142.4714" RightMargin="-281.4714" TopMargin="-28.2433" BottomMargin="-22.7567" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="63" Scale9Height="59" ctype="ImageViewObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="211.9714" Y="2.7433" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="hall/plist/bj0.png" Plist="hall/plist/promotor.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Image_3" ActionTag="2035098410" Tag="222" IconVisible="False" LeftMargin="281.4407" RightMargin="-420.4407" TopMargin="-28.2433" BottomMargin="-22.7567" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="63" Scale9Height="59" ctype="ImageViewObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="350.9407" Y="2.7433" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="hall/plist/bj0.png" Plist="hall/plist/promotor.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Image_4" ActionTag="-1677345842" Tag="223" IconVisible="False" LeftMargin="421.0115" RightMargin="-560.0115" TopMargin="-28.2433" BottomMargin="-22.7567" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="63" Scale9Height="59" ctype="ImageViewObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="490.5115" Y="2.7433" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="hall/plist/bj0.png" Plist="hall/plist/promotor.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Image_5" ActionTag="-1305679774" Tag="224" IconVisible="False" LeftMargin="559.5823" RightMargin="-698.5823" TopMargin="-28.2433" BottomMargin="-22.7567" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="63" Scale9Height="59" ctype="ImageViewObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="629.0823" Y="2.7433" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="hall/plist/bj0.png" Plist="hall/plist/promotor.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Image_6" ActionTag="166621011" Tag="225" IconVisible="False" LeftMargin="699.1517" RightMargin="-838.1517" TopMargin="-28.2433" BottomMargin="-22.7567" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="63" Scale9Height="59" ctype="ImageViewObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="768.6517" Y="2.7433" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="hall/plist/bj0.png" Plist="hall/plist/promotor.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_1" ActionTag="567304065" Tag="226" IconVisible="False" LeftMargin="74.6805" RightMargin="-74.6805" TopMargin="-2.2941" BottomMargin="2.2941" FontSize="20" LabelText="" HorizontalAlignmentType="HT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
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
                      <AbstractNodeData Name="Text_2" ActionTag="-1649023506" Tag="227" IconVisible="False" LeftMargin="213.9604" RightMargin="-213.9604" TopMargin="-2.2941" BottomMargin="2.2941" FontSize="20" LabelText="" HorizontalAlignmentType="HT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
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
                      <AbstractNodeData Name="Text_3" ActionTag="-424498813" Tag="228" IconVisible="False" LeftMargin="283.7416" RightMargin="-422.7416" TopMargin="-27.7941" BottomMargin="-23.2059" IsCustomSize="True" FontSize="18" LabelText="" HorizontalAlignmentType="HT_Center" VerticalAlignmentType="VT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="353.2416" Y="2.2941" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="108" G="59" B="27" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_4" ActionTag="792373724" Tag="229" IconVisible="False" LeftMargin="423.0211" RightMargin="-562.0211" TopMargin="-27.7941" BottomMargin="-23.2059" IsCustomSize="True" FontSize="18" LabelText="" HorizontalAlignmentType="HT_Center" VerticalAlignmentType="VT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="492.5211" Y="2.2941" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="108" G="59" B="27" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_5" ActionTag="2081575896" Tag="230" IconVisible="False" LeftMargin="631.8009" RightMargin="-631.8009" TopMargin="-2.2941" BottomMargin="2.2941" FontSize="20" LabelText="" HorizontalAlignmentType="HT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
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
                      <AbstractNodeData Name="Text_6" ActionTag="-2079069147" Tag="231" IconVisible="False" LeftMargin="771.0809" RightMargin="-771.0809" TopMargin="-2.2941" BottomMargin="2.2941" FontSize="20" LabelText="" HorizontalAlignmentType="HT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
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
                      <AbstractNodeData Name="Button_beAgent" ActionTag="1869045205" Tag="680" IconVisible="False" LeftMargin="693.0000" RightMargin="-847.0000" TopMargin="-29.0000" BottomMargin="-21.0000" TouchEnable="True" FontSize="26" ButtonText="开通代理" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="4" BottomEage="4" Scale9OriginX="15" Scale9OriginY="4" Scale9Width="124" Scale9Height="42" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                        <Size X="154.0000" Y="50.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="770.0000" Y="4.0000" />
                        <Scale ScaleX="0.6400" ScaleY="0.6400" />
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
                    <Position X="-21.6500" Y="192.4000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="-0.0290" Y="0.3665" />
                    <PreSize X="0.0000" Y="0.0000" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="node_item_8" ActionTag="-1835554274" Tag="232" IconVisible="True" LeftMargin="-21.6500" RightMargin="767.6500" TopMargin="383.5900" BottomMargin="141.4100" ctype="SingleNodeObjectData">
                    <Size X="0.0000" Y="0.0000" />
                    <Children>
                      <AbstractNodeData Name="Image_1" ActionTag="-455065750" Tag="233" IconVisible="False" LeftMargin="3.3060" RightMargin="-142.3060" TopMargin="-28.2433" BottomMargin="-22.7567" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="63" Scale9Height="59" ctype="ImageViewObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="72.8060" Y="2.7433" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="hall/plist/bj0.png" Plist="hall/plist/promotor.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Image_2" ActionTag="-1978597515" Tag="234" IconVisible="False" LeftMargin="142.4714" RightMargin="-281.4714" TopMargin="-28.2433" BottomMargin="-22.7567" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="63" Scale9Height="59" ctype="ImageViewObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="211.9714" Y="2.7433" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="hall/plist/bj0.png" Plist="hall/plist/promotor.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Image_3" ActionTag="-1838843941" Tag="235" IconVisible="False" LeftMargin="281.4407" RightMargin="-420.4407" TopMargin="-28.2433" BottomMargin="-22.7567" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="63" Scale9Height="59" ctype="ImageViewObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="350.9407" Y="2.7433" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="hall/plist/bj0.png" Plist="hall/plist/promotor.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Image_4" ActionTag="1570522036" Tag="236" IconVisible="False" LeftMargin="421.0115" RightMargin="-560.0115" TopMargin="-28.2433" BottomMargin="-22.7567" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="63" Scale9Height="59" ctype="ImageViewObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="490.5115" Y="2.7433" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="hall/plist/bj0.png" Plist="hall/plist/promotor.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Image_5" ActionTag="1482954988" Tag="237" IconVisible="False" LeftMargin="559.5823" RightMargin="-698.5823" TopMargin="-28.2433" BottomMargin="-22.7567" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="63" Scale9Height="59" ctype="ImageViewObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="629.0823" Y="2.7433" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="hall/plist/bj0.png" Plist="hall/plist/promotor.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Image_6" ActionTag="-384755424" Tag="238" IconVisible="False" LeftMargin="699.1517" RightMargin="-838.1517" TopMargin="-28.2433" BottomMargin="-22.7567" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="63" Scale9Height="59" ctype="ImageViewObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="768.6517" Y="2.7433" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="hall/plist/bj0.png" Plist="hall/plist/promotor.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_1" ActionTag="-1891026099" Tag="239" IconVisible="False" LeftMargin="74.6805" RightMargin="-74.6805" TopMargin="-2.2941" BottomMargin="2.2941" FontSize="20" LabelText="" HorizontalAlignmentType="HT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
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
                      <AbstractNodeData Name="Text_2" ActionTag="244069063" Tag="240" IconVisible="False" LeftMargin="213.9604" RightMargin="-213.9604" TopMargin="-2.2941" BottomMargin="2.2941" FontSize="20" LabelText="" HorizontalAlignmentType="HT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
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
                      <AbstractNodeData Name="Text_3" ActionTag="1498394429" Tag="241" IconVisible="False" LeftMargin="283.7416" RightMargin="-422.7416" TopMargin="-27.7941" BottomMargin="-23.2059" IsCustomSize="True" FontSize="18" LabelText="" HorizontalAlignmentType="HT_Center" VerticalAlignmentType="VT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="353.2416" Y="2.2941" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="108" G="59" B="27" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_4" ActionTag="1246446534" Tag="242" IconVisible="False" LeftMargin="423.0211" RightMargin="-562.0211" TopMargin="-27.7941" BottomMargin="-23.2059" IsCustomSize="True" FontSize="18" LabelText="" HorizontalAlignmentType="HT_Center" VerticalAlignmentType="VT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="139.0000" Y="51.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="492.5211" Y="2.2941" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="108" G="59" B="27" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_5" ActionTag="894797430" Tag="243" IconVisible="False" LeftMargin="631.8009" RightMargin="-631.8009" TopMargin="-2.2941" BottomMargin="2.2941" FontSize="20" LabelText="" HorizontalAlignmentType="HT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
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
                      <AbstractNodeData Name="Text_6" ActionTag="1042789481" Tag="244" IconVisible="False" LeftMargin="771.0809" RightMargin="-771.0809" TopMargin="-2.2941" BottomMargin="2.2941" FontSize="20" LabelText="" HorizontalAlignmentType="HT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
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
                      <AbstractNodeData Name="Button_beAgent" ActionTag="1201463612" Tag="684" IconVisible="False" LeftMargin="693.0000" RightMargin="-847.0000" TopMargin="-29.0000" BottomMargin="-21.0000" TouchEnable="True" FontSize="26" ButtonText="开通代理" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="4" BottomEage="4" Scale9OriginX="15" Scale9OriginY="4" Scale9Width="124" Scale9Height="42" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                        <Size X="154.0000" Y="50.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="770.0000" Y="4.0000" />
                        <Scale ScaleX="0.6400" ScaleY="0.6400" />
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
                    <Position X="-21.6500" Y="141.4100" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="-0.0290" Y="0.2694" />
                    <PreSize X="0.0000" Y="0.0000" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Node_pop" Visible="False" ActionTag="815255988" Tag="688" IconVisible="True" LeftMargin="71.7806" RightMargin="674.2194" TopMargin="455.7785" BottomMargin="69.2215" ctype="SingleNodeObjectData">
                    <Size X="0.0000" Y="0.0000" />
                    <Children>
                      <AbstractNodeData Name="Button_Save_0" ActionTag="-1654179716" Tag="1025" IconVisible="False" LeftMargin="270.1149" RightMargin="-330.1149" TopMargin="-267.2369" BottomMargin="237.2369" TouchEnable="True" FontSize="30" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="-15" Scale9OriginY="-11" Scale9Width="30" Scale9Height="22" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
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
                      <AbstractNodeData Name="Image_7" ActionTag="1476397218" Tag="686" IconVisible="False" LeftMargin="81.1370" RightMargin="-567.1370" TopMargin="-426.5960" BottomMargin="115.5960" Scale9Enable="True" LeftEage="19" RightEage="24" TopEage="15" BottomEage="14" Scale9OriginX="19" Scale9OriginY="15" Scale9Width="198" Scale9Height="142" ctype="ImageViewObjectData">
                        <Size X="486.0000" Y="311.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="324.1370" Y="271.0960" />
                        <Scale ScaleX="1.5197" ScaleY="1.5029" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="tkbj.png" Plist="hall/plist/gui-agentpop.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="input_bg1" ActionTag="-1101983586" Tag="328" IconVisible="False" LeftMargin="211.4099" RightMargin="-589.4099" TopMargin="-467.6632" BottomMargin="414.6632" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="17" Scale9Height="15" ctype="ImageViewObjectData">
                        <Size X="378.0000" Y="53.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="400.4099" Y="441.1632" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="kko.png" Plist="hall/plist/gui-agentpop.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="input_bg2" ActionTag="-1581289650" Tag="330" IconVisible="False" LeftMargin="212.6930" RightMargin="-590.6930" TopMargin="-295.8741" BottomMargin="242.8741" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="17" Scale9Height="15" ctype="ImageViewObjectData">
                        <Size X="378.0000" Y="53.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="401.6930" Y="269.3741" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="kko.png" Plist="hall/plist/gui-agentpop.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="input_bg4" ActionTag="252104849" Tag="331" IconVisible="False" LeftMargin="336.2946" RightMargin="-587.2946" TopMargin="-210.0772" BottomMargin="157.0772" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="17" Scale9Height="15" ctype="ImageViewObjectData">
                        <Size X="251.0000" Y="53.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="461.7946" Y="183.5772" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="PlistSubImage" Path="kko.png" Plist="hall/plist/gui-agentpop.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_33" ActionTag="1698664777" Tag="919" IconVisible="False" LeftMargin="50.5349" RightMargin="-155.5349" TopMargin="-455.3302" BottomMargin="425.3302" FontSize="30" LabelText="账户ID:" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
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
                      <AbstractNodeData Name="Text_33_0" ActionTag="2088002270" Tag="920" IconVisible="False" LeftMargin="55.6547" RightMargin="-130.6547" TopMargin="-372.8934" BottomMargin="342.8934" FontSize="30" LabelText="等级:" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
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
                      <AbstractNodeData Name="Text_33_1" ActionTag="-1320138594" Tag="921" IconVisible="False" LeftMargin="64.7683" RightMargin="-139.7683" TopMargin="-283.3313" BottomMargin="253.3313" FontSize="30" LabelText="占成:" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
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
                      <AbstractNodeData Name="Text_33_2" ActionTag="1454971508" Tag="922" IconVisible="False" LeftMargin="50.1147" RightMargin="-305.1147" TopMargin="-197.1501" BottomMargin="167.1501" FontSize="30" LabelText="禁止创建下级代理:" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
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
                      <AbstractNodeData Name="Button_Cancel" ActionTag="-939582989" Tag="991" IconVisible="False" LeftMargin="106.1852" RightMargin="-231.1852" TopMargin="-122.8386" BottomMargin="72.8386" TouchEnable="True" FontSize="30" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="95" Scale9Height="28" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
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
                      <AbstractNodeData Name="Button_Save" ActionTag="-1586876244" Tag="992" IconVisible="False" LeftMargin="422.5207" RightMargin="-547.5207" TopMargin="-126.9428" BottomMargin="76.9428" TouchEnable="True" FontSize="30" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="95" Scale9Height="28" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
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
                      <AbstractNodeData Name="node_pop" ActionTag="1050578556" Tag="960" IconVisible="False" LeftMargin="214.6800" RightMargin="-592.6800" TopMargin="-323.5200" BottomMargin="-46.4800" TouchEnable="True" ClipAble="False" BackColorAlpha="100" ColorAngle="0.0000" Scale9Width="1" Scale9Height="1" ctype="PanelObjectData">
                        <Size X="378.0000" Y="370.0000" />
                        <Children>
                          <AbstractNodeData Name="IMG_selectBg" ActionTag="1349110299" Tag="961" IconVisible="False" LeftMargin="130.5908" RightMargin="130.4092" TopMargin="151.2419" BottomMargin="139.7581" Scale9Enable="True" LeftEage="4" RightEage="4" TopEage="4" BottomEage="4" Scale9OriginX="4" Scale9OriginY="4" Scale9Width="63" Scale9Height="59" ctype="ImageViewObjectData">
                            <Size X="117.0000" Y="79.0000" />
                            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                            <Position X="189.0908" Y="179.2581" />
                            <Scale ScaleX="3.2306" ScaleY="4.8763" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition X="0.5002" Y="0.4845" />
                            <PreSize X="0.3095" Y="0.2135" />
                            <FileData Type="PlistSubImage" Path="hall/plist/bj0.png" Plist="hall/plist/promotor.plist" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="IMG_line1" ActionTag="-1644468945" Tag="966" IconVisible="False" LeftMargin="36.5588" RightMargin="33.4412" TopMargin="26.3811" BottomMargin="341.6189" ctype="SpriteObjectData">
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
                          <AbstractNodeData Name="IMG_line2_1" ActionTag="-1055621796" Tag="978" IconVisible="False" LeftMargin="36.5588" RightMargin="33.4412" TopMargin="316.2159" BottomMargin="51.7841" ctype="SpriteObjectData">
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
                          <AbstractNodeData Name="IMG_line2_0" ActionTag="2127319211" Tag="977" IconVisible="False" LeftMargin="36.5588" RightMargin="33.4412" TopMargin="283.6339" BottomMargin="84.3661" ctype="SpriteObjectData">
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
                          <AbstractNodeData Name="IMG_line3" ActionTag="-808047020" Tag="976" IconVisible="False" LeftMargin="36.0795" RightMargin="33.9205" TopMargin="252.3925" BottomMargin="115.6075" ctype="SpriteObjectData">
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
                          <AbstractNodeData Name="IMG_line2" ActionTag="250508069" Tag="971" IconVisible="False" LeftMargin="36.5588" RightMargin="33.4412" TopMargin="59.6112" BottomMargin="308.3888" ctype="SpriteObjectData">
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
                          <AbstractNodeData Name="IMG_line2_2" ActionTag="949470236" Tag="333" IconVisible="False" LeftMargin="36.5588" RightMargin="33.4412" TopMargin="90.8397" BottomMargin="277.1603" ctype="SpriteObjectData">
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
                          <AbstractNodeData Name="IMG_line2_3" ActionTag="1701868039" Tag="334" IconVisible="False" LeftMargin="36.5588" RightMargin="33.4412" TopMargin="125.0695" BottomMargin="242.9305" ctype="SpriteObjectData">
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
                          <AbstractNodeData Name="IMG_line2_4" ActionTag="-1577674534" Tag="335" IconVisible="False" LeftMargin="36.5588" RightMargin="33.4412" TopMargin="157.2995" BottomMargin="210.7005" ctype="SpriteObjectData">
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
                          <AbstractNodeData Name="IMG_line2_4_0" ActionTag="-1225893095" Tag="338" IconVisible="False" LeftMargin="36.5588" RightMargin="33.4412" TopMargin="189.5298" BottomMargin="178.4702" ctype="SpriteObjectData">
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
                          <AbstractNodeData Name="IMG_line2_6" ActionTag="1044589888" Tag="337" IconVisible="False" LeftMargin="33.9210" RightMargin="36.0790" TopMargin="220.4492" BottomMargin="147.5508" ctype="SpriteObjectData">
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
                          <AbstractNodeData Name="IMG_line2_6_0" ActionTag="-854116924" Tag="339" IconVisible="False" LeftMargin="33.9191" RightMargin="36.0809" TopMargin="352.4496" BottomMargin="15.5504" ctype="SpriteObjectData">
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
                          <AbstractNodeData Name="node_1" ActionTag="-2064542705" Tag="962" IconVisible="False" LeftMargin="0.7501" RightMargin="-2.7501" TopMargin="-2.2288" BottomMargin="343.2288" ClipAble="False" BackColorAlpha="100" ColorAngle="0.0000" Scale9Width="1" Scale9Height="1" ctype="PanelObjectData">
                            <Size X="380.0000" Y="29.0000" />
                            <Children>
                              <AbstractNodeData Name="BTN_select" ActionTag="344173854" Tag="963" IconVisible="False" LeftMargin="6.5000" RightMargin="-3.5000" TopMargin="-2.0000" BottomMargin="-3.0000" TouchEnable="True" FontSize="14" Scale9Width="1" Scale9Height="1" OutlineSize="0" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ctype="ButtonObjectData">
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
                              <AbstractNodeData Name="LB_type" ActionTag="-1844737742" Tag="964" IconVisible="False" LeftMargin="141.7500" RightMargin="158.2500" TopMargin="4.7000" BottomMargin="4.3000" FontSize="20" LabelText="金众大使" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
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
                          <AbstractNodeData Name="node_2" ActionTag="440687067" Tag="967" IconVisible="False" LeftMargin="0.7501" RightMargin="-2.7501" TopMargin="30.2269" BottomMargin="310.7731" ClipAble="False" BackColorAlpha="100" ColorAngle="0.0000" Scale9Width="1" Scale9Height="1" ctype="PanelObjectData">
                            <Size X="380.0000" Y="29.0000" />
                            <Children>
                              <AbstractNodeData Name="BTN_select" ActionTag="-1154329031" Tag="968" IconVisible="False" LeftMargin="6.5000" RightMargin="-3.5000" TopMargin="-2.0000" BottomMargin="-3.0000" TouchEnable="True" FontSize="14" Scale9Width="1" Scale9Height="1" OutlineSize="0" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ctype="ButtonObjectData">
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
                              <AbstractNodeData Name="LB_type" ActionTag="-1442942776" Tag="969" IconVisible="False" LeftMargin="138.7500" RightMargin="161.2500" TopMargin="2.7033" BottomMargin="6.2967" FontSize="20" LabelText="资深董事" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
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
                          <AbstractNodeData Name="node_3" ActionTag="883987884" Tag="972" IconVisible="False" LeftMargin="0.7501" RightMargin="-2.7501" TopMargin="62.6826" BottomMargin="278.3174" ClipAble="False" BackColorAlpha="100" ColorAngle="0.0000" Scale9Width="1" Scale9Height="1" ctype="PanelObjectData">
                            <Size X="380.0000" Y="29.0000" />
                            <Children>
                              <AbstractNodeData Name="BTN_select" ActionTag="6615437" Tag="973" IconVisible="False" LeftMargin="6.5000" RightMargin="-3.5000" TopMargin="-2.0000" BottomMargin="-3.0000" TouchEnable="True" FontSize="14" Scale9Width="1" Scale9Height="1" OutlineSize="0" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ctype="ButtonObjectData">
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
                              <AbstractNodeData Name="LB_type" ActionTag="1242886990" Tag="974" IconVisible="False" LeftMargin="139.3000" RightMargin="160.7000" TopMargin="2.7024" BottomMargin="6.2976" FontSize="20" LabelText="高级董事" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
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
                          <AbstractNodeData Name="node_4" ActionTag="-656819443" Tag="979" IconVisible="False" LeftMargin="0.7501" RightMargin="-2.7501" TopMargin="95.1380" BottomMargin="245.8620" ClipAble="False" BackColorAlpha="100" ColorAngle="0.0000" Scale9Width="1" Scale9Height="1" ctype="PanelObjectData">
                            <Size X="380.0000" Y="29.0000" />
                            <Children>
                              <AbstractNodeData Name="BTN_select" ActionTag="-1378720271" Tag="980" IconVisible="False" LeftMargin="6.5000" RightMargin="-3.5000" TopMargin="-2.0000" BottomMargin="-3.0000" TouchEnable="True" FontSize="14" Scale9Width="1" Scale9Height="1" OutlineSize="0" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ctype="ButtonObjectData">
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
                              <AbstractNodeData Name="LB_type" ActionTag="1379199300" Tag="332" IconVisible="False" LeftMargin="161.7500" RightMargin="178.2500" TopMargin="2.7014" BottomMargin="6.2986" FontSize="20" LabelText="董事" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
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
                          <AbstractNodeData Name="node_5" ActionTag="1331163160" Tag="983" IconVisible="False" LeftMargin="0.7501" RightMargin="-2.7501" TopMargin="127.5939" BottomMargin="213.4061" ClipAble="False" BackColorAlpha="100" ColorAngle="0.0000" Scale9Width="1" Scale9Height="1" ctype="PanelObjectData">
                            <Size X="380.0000" Y="29.0000" />
                            <Children>
                              <AbstractNodeData Name="BTN_select" ActionTag="15464821" Tag="984" IconVisible="False" LeftMargin="6.5000" RightMargin="-3.5000" TopMargin="-2.0000" BottomMargin="-3.0000" TouchEnable="True" FontSize="14" Scale9Width="1" Scale9Height="1" OutlineSize="0" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ctype="ButtonObjectData">
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
                              <AbstractNodeData Name="LB_type" ActionTag="1305089564" Tag="985" IconVisible="False" LeftMargin="140.7500" RightMargin="159.2500" TopMargin="3.7000" BottomMargin="5.3000" FontSize="20" LabelText="资深总监" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
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
                          <AbstractNodeData Name="node_6" ActionTag="-1822116417" Tag="987" IconVisible="False" LeftMargin="0.7501" RightMargin="-2.7501" TopMargin="160.0500" BottomMargin="180.9500" ClipAble="False" BackColorAlpha="100" ColorAngle="0.0000" Scale9Width="1" Scale9Height="1" ctype="PanelObjectData">
                            <Size X="380.0000" Y="29.0000" />
                            <Children>
                              <AbstractNodeData Name="BTN_select" ActionTag="-838868423" Tag="988" IconVisible="False" LeftMargin="6.5000" RightMargin="-3.5000" TopMargin="-2.0000" BottomMargin="-3.0000" TouchEnable="True" FontSize="14" Scale9Width="1" Scale9Height="1" OutlineSize="0" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ctype="ButtonObjectData">
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
                              <AbstractNodeData Name="LB_type" ActionTag="-1967462967" Tag="989" IconVisible="False" LeftMargin="141.1000" RightMargin="158.9000" TopMargin="2.6993" BottomMargin="6.3007" FontSize="20" LabelText="高级总监" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
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
                          <AbstractNodeData Name="node_7" ActionTag="1208168628" Tag="303" IconVisible="False" LeftMargin="0.7501" RightMargin="-2.7501" TopMargin="192.5053" BottomMargin="148.4947" ClipAble="False" BackColorAlpha="100" ColorAngle="0.0000" Scale9Width="1" Scale9Height="1" ctype="PanelObjectData">
                            <Size X="380.0000" Y="29.0000" />
                            <Children>
                              <AbstractNodeData Name="BTN_select" ActionTag="-1624041178" Tag="304" IconVisible="False" LeftMargin="6.5000" RightMargin="-3.5000" TopMargin="-2.0000" BottomMargin="-3.0000" TouchEnable="True" FontSize="14" Scale9Width="1" Scale9Height="1" OutlineSize="0" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ctype="ButtonObjectData">
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
                              <AbstractNodeData Name="LB_type" ActionTag="-371758125" Tag="305" IconVisible="False" LeftMargin="160.7500" RightMargin="179.2500" TopMargin="2.7038" BottomMargin="6.2962" FontSize="20" LabelText="总监" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
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
                          <AbstractNodeData Name="node_8" ActionTag="1724296403" Tag="307" IconVisible="False" LeftMargin="0.7501" RightMargin="-2.7501" TopMargin="224.9613" BottomMargin="116.0387" ClipAble="False" BackColorAlpha="100" ColorAngle="0.0000" Scale9Width="1" Scale9Height="1" ctype="PanelObjectData">
                            <Size X="380.0000" Y="29.0000" />
                            <Children>
                              <AbstractNodeData Name="BTN_select" ActionTag="1461076685" Tag="308" IconVisible="False" LeftMargin="6.5000" RightMargin="-3.5000" TopMargin="-2.0000" BottomMargin="-3.0000" TouchEnable="True" FontSize="14" Scale9Width="1" Scale9Height="1" OutlineSize="0" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ctype="ButtonObjectData">
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
                              <AbstractNodeData Name="LB_type" ActionTag="1090456210" Tag="309" IconVisible="False" LeftMargin="141.1000" RightMargin="158.9000" TopMargin="1.9100" BottomMargin="7.0900" FontSize="20" LabelText="高级经理" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
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
                          <AbstractNodeData Name="node_9" ActionTag="892454237" Tag="311" IconVisible="False" LeftMargin="0.7501" RightMargin="-2.7501" TopMargin="257.4173" BottomMargin="83.5827" ClipAble="False" BackColorAlpha="100" ColorAngle="0.0000" Scale9Width="1" Scale9Height="1" ctype="PanelObjectData">
                            <Size X="380.0000" Y="29.0000" />
                            <Children>
                              <AbstractNodeData Name="BTN_select" ActionTag="1867988382" Tag="312" IconVisible="False" LeftMargin="6.5000" RightMargin="-3.5000" TopMargin="-2.0000" BottomMargin="-3.0000" TouchEnable="True" FontSize="14" Scale9Width="1" Scale9Height="1" OutlineSize="0" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ctype="ButtonObjectData">
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
                              <AbstractNodeData Name="LB_type" ActionTag="771589736" Tag="313" IconVisible="False" LeftMargin="158.7500" RightMargin="181.2500" TopMargin="2.7032" BottomMargin="6.2968" FontSize="20" LabelText="经理" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
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
                          <AbstractNodeData Name="node_10" ActionTag="-1249741182" Tag="315" IconVisible="False" LeftMargin="0.7501" RightMargin="-2.7501" TopMargin="289.8731" BottomMargin="51.1269" ClipAble="False" BackColorAlpha="100" ColorAngle="0.0000" Scale9Width="1" Scale9Height="1" ctype="PanelObjectData">
                            <Size X="380.0000" Y="29.0000" />
                            <Children>
                              <AbstractNodeData Name="BTN_select" ActionTag="-539116061" Tag="316" IconVisible="False" LeftMargin="6.5000" RightMargin="-3.5000" TopMargin="-2.0000" BottomMargin="-3.0000" TouchEnable="True" FontSize="14" Scale9Width="1" Scale9Height="1" OutlineSize="0" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ctype="ButtonObjectData">
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
                              <AbstractNodeData Name="LB_type" ActionTag="328534670" Tag="317" IconVisible="False" LeftMargin="140.8900" RightMargin="159.1100" TopMargin="-1.4893" BottomMargin="10.4893" FontSize="20" LabelText="高级主任" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
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
                          <AbstractNodeData Name="node_11" ActionTag="230281340" Tag="319" IconVisible="False" LeftMargin="0.7501" RightMargin="-2.7501" TopMargin="322.3287" BottomMargin="18.6713" ClipAble="False" BackColorAlpha="100" ColorAngle="0.0000" LeftEage="50" RightEage="50" TopEage="16" BottomEage="16" Scale9OriginX="-50" Scale9OriginY="-16" Scale9Width="100" Scale9Height="32" ctype="PanelObjectData">
                            <Size X="380.0000" Y="29.0000" />
                            <Children>
                              <AbstractNodeData Name="BTN_select" ActionTag="1878557775" Tag="320" IconVisible="False" LeftMargin="6.5000" RightMargin="-3.5000" TopMargin="-2.0000" BottomMargin="-3.0000" TouchEnable="True" FontSize="14" Scale9Width="1" Scale9Height="1" OutlineSize="0" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ctype="ButtonObjectData">
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
                              <AbstractNodeData Name="LB_type" ActionTag="-1347560548" Tag="321" IconVisible="False" LeftMargin="161.0234" RightMargin="178.9766" TopMargin="0.6809" BottomMargin="8.3191" FontSize="20" LabelText="主任" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
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
                          <AbstractNodeData Name="node_12" ActionTag="998616109" Tag="400" IconVisible="False" LeftMargin="0.5400" RightMargin="-2.5400" TopMargin="354.4694" BottomMargin="-13.4694" ClipAble="False" BackColorAlpha="100" ColorAngle="0.0000" LeftEage="50" RightEage="50" TopEage="16" BottomEage="16" Scale9OriginX="-50" Scale9OriginY="-16" Scale9Width="100" Scale9Height="32" ctype="PanelObjectData">
                            <Size X="380.0000" Y="29.0000" />
                            <Children>
                              <AbstractNodeData Name="BTN_select" ActionTag="743858518" Tag="401" IconVisible="False" LeftMargin="6.5000" RightMargin="-3.5000" TopMargin="-2.0000" BottomMargin="-3.0000" TouchEnable="True" FontSize="14" Scale9Width="1" Scale9Height="1" OutlineSize="0" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ctype="ButtonObjectData">
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
                              <AbstractNodeData Name="LB_type" ActionTag="-1182448970" Tag="402" IconVisible="False" LeftMargin="161.0234" RightMargin="178.9766" TopMargin="0.6809" BottomMargin="8.3191" FontSize="20" LabelText="助理" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
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
                      <AbstractNodeData Name="IMG_TypeBg" ActionTag="-1744363182" Tag="297" IconVisible="False" LeftMargin="214.6361" RightMargin="-592.6361" TopMargin="-375.9307" BottomMargin="322.9307" Scale9Enable="True" LeftEage="8" RightEage="8" TopEage="7" BottomEage="7" Scale9OriginX="8" Scale9OriginY="7" Scale9Width="9" Scale9Height="9" ctype="ImageViewObjectData">
                        <Size X="378.0000" Y="53.0000" />
                        <Children>
                          <AbstractNodeData Name="BTN_push" ActionTag="-1915945570" Tag="298" IconVisible="False" LeftMargin="323.4071" RightMargin="16.5929" TopMargin="14.7614" BottomMargin="14.2386" TouchEnable="True" FontSize="14" LeftEage="12" RightEage="12" TopEage="7" BottomEage="7" Scale9OriginX="12" Scale9OriginY="7" Scale9Width="14" Scale9Height="10" OutlineSize="0" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ctype="ButtonObjectData">
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
                          <AbstractNodeData Name="BTN_pull" ActionTag="-688245312" Tag="299" IconVisible="False" LeftMargin="323.4071" RightMargin="16.5929" TopMargin="14.7614" BottomMargin="14.2386" TouchEnable="True" FontSize="14" LeftEage="12" RightEage="12" TopEage="7" BottomEage="7" Scale9OriginX="12" Scale9OriginY="7" Scale9Width="14" Scale9Height="10" OutlineSize="0" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ctype="ButtonObjectData">
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
                          <AbstractNodeData Name="LB_selectType" ActionTag="886981724" Tag="300" IconVisible="False" LeftMargin="134.1100" RightMargin="143.8900" TopMargin="15.1428" BottomMargin="12.8572" FontSize="25" LabelText="金众大使" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
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
                          <AbstractNodeData Name="BTN_select" ActionTag="248099339" Tag="302" IconVisible="False" LeftMargin="27.2620" RightMargin="30.7380" TopMargin="5.5240" BottomMargin="7.4760" TouchEnable="True" FontSize="14" Scale9Width="1" Scale9Height="1" OutlineSize="0" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ctype="ButtonObjectData">
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