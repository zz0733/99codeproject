<GameFile>
  <PropertyGroup Name="LoginScene" Type="Layer" ID="ac10e1d4-094b-4aee-9dd4-2ddebee9d547" Version="3.10.0.0" />
  <Content ctype="GameProjectContent">
    <Content>
      <Animation Duration="40" Speed="1.0000">
        <Timeline ActionTag="-1391326620" Property="RotationSkew">
          <ScaleFrame FrameIndex="0" X="0.0000" Y="-0.0026">
            <EasingData Type="0" />
          </ScaleFrame>
          <ScaleFrame FrameIndex="10" X="90.0000" Y="89.9974">
            <EasingData Type="0" />
          </ScaleFrame>
          <ScaleFrame FrameIndex="20" X="180.0000" Y="179.9974">
            <EasingData Type="0" />
          </ScaleFrame>
          <ScaleFrame FrameIndex="40" X="360.0000" Y="359.9974">
            <EasingData Type="0" />
          </ScaleFrame>
        </Timeline>
        <Timeline ActionTag="628386222" Property="RotationSkew">
          <ScaleFrame FrameIndex="0" X="0.0000" Y="-0.0035">
            <EasingData Type="0" />
          </ScaleFrame>
          <ScaleFrame FrameIndex="10" X="90.0000" Y="89.9965">
            <EasingData Type="0" />
          </ScaleFrame>
          <ScaleFrame FrameIndex="20" X="180.0000" Y="179.9965">
            <EasingData Type="0" />
          </ScaleFrame>
          <ScaleFrame FrameIndex="30" X="270.0000" Y="269.9965">
            <EasingData Type="0" />
          </ScaleFrame>
          <ScaleFrame FrameIndex="40" X="360.0000" Y="359.9965">
            <EasingData Type="0" />
          </ScaleFrame>
        </Timeline>
        <Timeline ActionTag="-1955056196" Property="Scale">
          <ScaleFrame FrameIndex="0" X="1.0000" Y="1.0000">
            <EasingData Type="0" />
          </ScaleFrame>
          <ScaleFrame FrameIndex="10" X="-0.0290" Y="1.0000">
            <EasingData Type="0" />
          </ScaleFrame>
          <ScaleFrame FrameIndex="20" X="-1.0000" Y="1.0000">
            <EasingData Type="0" />
          </ScaleFrame>
        </Timeline>
        <Timeline ActionTag="-1955056196" Property="RotationSkew">
          <ScaleFrame FrameIndex="0" X="0.0000" Y="0.0000">
            <EasingData Type="0" />
          </ScaleFrame>
          <ScaleFrame FrameIndex="10" X="0.0000" Y="0.0000">
            <EasingData Type="0" />
          </ScaleFrame>
          <ScaleFrame FrameIndex="20" X="0.0000" Y="0.0000">
            <EasingData Type="0" />
          </ScaleFrame>
        </Timeline>
      </Animation>
      <AnimationList>
        <AnimationInfo Name="quan" StartIndex="0" EndIndex="40">
          <RenderColor A="255" R="58" G="141" B="134" />
        </AnimationInfo>
      </AnimationList>
      <ObjectData Name="Scene" ctype="GameLayerObjectData">
        <Size X="1280.0000" Y="720.0000" />
        <Children>
          <AbstractNodeData Name="node_rootUI" ActionTag="-1496906733" Tag="174" IconVisible="False" TouchEnable="True" ClipAble="False" BackColorAlpha="102" ColorAngle="0.0000" Scale9Width="1" Scale9Height="1" ctype="PanelObjectData">
            <Size X="1280.0000" Y="720.0000" />
            <Children>
              <AbstractNodeData Name="Image_1" ActionTag="700475722" Tag="1007" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="1.0240" RightMargin="-1.0240" Scale9Width="1280" Scale9Height="720" ctype="ImageViewObjectData">
                <Size X="1280.0000" Y="720.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="641.0240" Y="360.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.5008" Y="0.5000" />
                <PreSize X="1.0000" Y="1.0000" />
                <FileData Type="Normal" Path="login/image/loading/zcm_zjm_bg.jpg" Plist="" />
              </AbstractNodeData>
              <AbstractNodeData Name="IMG_loadBg" ActionTag="662801045" Tag="936" IconVisible="False" TopMargin="534.3900" BottomMargin="5.6100" LeftEage="191" RightEage="191" TopEage="14" BottomEage="14" Scale9OriginX="191" Scale9OriginY="14" Scale9Width="199" Scale9Height="16" ctype="ImageViewObjectData">
                <Size X="1280.0000" Y="180.0000" />
                <Children>
                  <AbstractNodeData Name="Text_Up" ActionTag="-538196551" Tag="937" IconVisible="False" LeftMargin="479.9998" RightMargin="480.0002" TopMargin="71.0003" BottomMargin="88.9997" FontSize="20" LabelText="正在加载资源(加载资源不消耗流量)" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                    <Size X="320.0000" Y="20.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="639.9998" Y="98.9997" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.5000" Y="0.5500" />
                    <PreSize X="0.2500" Y="0.1111" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="110" G="110" B="110" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Image_Bar" ActionTag="-816037749" Tag="938" IconVisible="False" LeftMargin="251.5000" RightMargin="251.5000" TopMargin="100.5000" BottomMargin="60.5000" LeftEage="256" RightEage="256" TopEage="6" BottomEage="6" Scale9OriginX="256" Scale9OriginY="6" Scale9Width="265" Scale9Height="7" ctype="ImageViewObjectData">
                    <Size X="777.0000" Y="19.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="640.0000" Y="70.0000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.5000" Y="0.3889" />
                    <PreSize X="0.6070" Y="0.1056" />
                    <FileData Type="Normal" Path="login/image/loading/tjylc_loading_jdt1.png" Plist="" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Progress_bar" ActionTag="1019112250" Tag="940" IconVisible="False" LeftMargin="251.5000" RightMargin="251.5000" TopMargin="100.5000" BottomMargin="60.5000" ProgressInfo="20" ctype="LoadingBarObjectData">
                    <Size X="777.0000" Y="19.0000" />
                    <Children>
                      <AbstractNodeData Name="pt_header" ActionTag="-6699487" Tag="47" IconVisible="True" RightMargin="777.0000" TopMargin="19.0000" ctype="ParticleObjectData">
                        <Size X="0.0000" Y="0.0000" />
                        <AnchorPoint />
                        <Position />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="Normal" Path="login/image/loading/loading_eff.plist" Plist="" />
                        <BlendFunc Src="770" Dst="1" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="640.0000" Y="70.0000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.5000" Y="0.3889" />
                    <PreSize X="0.6070" Y="0.1056" />
                    <ImageFileData Type="Normal" Path="login/image/loading/tjylc_loading_jdt2.png" Plist="" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="640.0000" Y="95.6100" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.5000" Y="0.1328" />
                <PreSize X="1.0000" Y="0.2500" />
                <FileData Type="Normal" Path="login/image/loading/text_bg.png" Plist="" />
              </AbstractNodeData>
              <AbstractNodeData Name="nodeTitle" ActionTag="1893962865" Tag="209" IconVisible="True" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="640.0000" RightMargin="640.0000" TopMargin="360.0000" BottomMargin="360.0000" ctype="SingleNodeObjectData">
                <Size X="0.0000" Y="0.0000" />
                <Children>
                  <AbstractNodeData Name="sprite_logo" ActionTag="-645446572" Tag="1012" IconVisible="False" LeftMargin="-536.5000" RightMargin="-536.5000" TopMargin="-264.0000" BottomMargin="-114.0000" ctype="SpriteObjectData">
                    <Size X="1073.0000" Y="378.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position Y="75.0000" />
                    <Scale ScaleX="0.7000" ScaleY="0.7000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition />
                    <PreSize X="0.0000" Y="0.0000" />
                    <FileData Type="Normal" Path="login/image/zcmdwc_loading/logo3.png" Plist="" />
                    <BlendFunc Src="1" Dst="771" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint />
                <Position X="640.0000" Y="360.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.5000" Y="0.5000" />
                <PreSize X="0.0000" Y="0.0000" />
              </AbstractNodeData>
              <AbstractNodeData Name="IMG_toolBg" ActionTag="-354551629" Tag="221" IconVisible="True" PositionPercentXEnabled="True" LeftMargin="640.0000" RightMargin="640.0000" TopMargin="819.0000" BottomMargin="-99.0000" ctype="SingleNodeObjectData">
                <Size X="0.0000" Y="0.0000" />
                <Children>
                  <AbstractNodeData Name="BTN_guest" ActionTag="-136260422" Tag="220" IconVisible="False" LeftMargin="-555.3111" RightMargin="221.3111" TopMargin="-41.9700" BottomMargin="-61.0300" TouchEnable="True" FontSize="14" Scale9Width="334" Scale9Height="103" OutlineSize="0" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ctype="ButtonObjectData">
                    <Size X="334.0000" Y="103.0000" />
                    <Children>
                      <AbstractNodeData Name="title" ActionTag="1523704710" Tag="222" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="36.5000" RightMargin="36.5000" TopMargin="17.5036" BottomMargin="25.4964" ctype="SpriteObjectData">
                        <Size X="261.0000" Y="60.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="167.0000" Y="55.4964" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.5000" Y="0.5388" />
                        <PreSize X="0.7814" Y="0.5825" />
                        <FileData Type="Normal" Path="login/image/zcmdwc_loading/btntext_login1.png" Plist="" />
                        <BlendFunc Src="1" Dst="771" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="-388.3111" Y="-9.5300" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition />
                    <PreSize X="0.0000" Y="0.0000" />
                    <TextColor A="255" R="65" G="65" B="70" />
                    <NormalFileData Type="Normal" Path="login/image/zcmdwc_loading/btn_login1.png" Plist="" />
                    <OutlineColor A="255" R="0" G="63" B="198" />
                    <ShadowColor A="255" R="0" G="0" B="0" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="BTN_login" ActionTag="1594853791" Tag="219" IconVisible="False" LeftMargin="-163.9473" RightMargin="-170.0527" TopMargin="-41.9700" BottomMargin="-61.0300" TouchEnable="True" FontSize="14" Scale9Width="334" Scale9Height="103" OutlineSize="0" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ctype="ButtonObjectData">
                    <Size X="334.0000" Y="103.0000" />
                    <Children>
                      <AbstractNodeData Name="title" ActionTag="-952422014" Tag="236" IconVisible="False" LeftMargin="15.0967" RightMargin="33.9033" TopMargin="14.1200" BottomMargin="22.8800" ctype="SpriteObjectData">
                        <Size X="285.0000" Y="66.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="157.5967" Y="55.8800" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.4718" Y="0.5425" />
                        <PreSize X="0.8533" Y="0.6408" />
                        <FileData Type="Normal" Path="login/image/zcmdwc_loading/btntext_login2.png" Plist="" />
                        <BlendFunc Src="1" Dst="771" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="3.0527" Y="-9.5300" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition />
                    <PreSize X="0.0000" Y="0.0000" />
                    <TextColor A="255" R="65" G="65" B="70" />
                    <NormalFileData Type="Normal" Path="login/image/zcmdwc_loading/btn_login2.png" Plist="" />
                    <OutlineColor A="255" R="0" G="63" B="198" />
                    <ShadowColor A="255" R="0" G="0" B="0" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="BTN_account" ActionTag="1978611480" Tag="237" IconVisible="False" LeftMargin="226.6805" RightMargin="-560.6805" TopMargin="-41.9700" BottomMargin="-61.0300" TouchEnable="True" FontSize="14" Scale9Width="334" Scale9Height="103" OutlineSize="0" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ctype="ButtonObjectData">
                    <Size X="334.0000" Y="103.0000" />
                    <Children>
                      <AbstractNodeData Name="title" ActionTag="1636566763" Tag="238" IconVisible="False" LeftMargin="14.8804" RightMargin="34.1196" TopMargin="14.1200" BottomMargin="22.8800" ctype="SpriteObjectData">
                        <Size X="285.0000" Y="66.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="157.3804" Y="55.8800" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.4712" Y="0.5425" />
                        <PreSize X="0.8533" Y="0.6408" />
                        <FileData Type="Normal" Path="login/image/zcmdwc_loading/btntext_login3.png" Plist="" />
                        <BlendFunc Src="1" Dst="771" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="393.6805" Y="-9.5300" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition />
                    <PreSize X="0.0000" Y="0.0000" />
                    <TextColor A="255" R="65" G="65" B="70" />
                    <NormalFileData Type="Normal" Path="login/image/zcmdwc_loading/btn_login3.png" Plist="" />
                    <OutlineColor A="255" R="0" G="63" B="198" />
                    <ShadowColor A="255" R="0" G="0" B="0" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint />
                <Position X="640.0000" Y="-99.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.5000" Y="-0.1375" />
                <PreSize X="0.0000" Y="0.0000" />
              </AbstractNodeData>
              <AbstractNodeData Name="BTN_service" ActionTag="788269485" Tag="315" IconVisible="False" HorizontalEdge="RightEdge" VerticalEdge="TopEdge" LeftMargin="1128.0042" RightMargin="79.9958" TopMargin="21.9988" BottomMargin="618.0012" TouchEnable="True" FontSize="14" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="42" Scale9Height="58" OutlineSize="0" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ctype="ButtonObjectData">
                <Size X="72.0000" Y="80.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="1164.0042" Y="658.0012" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.9094" Y="0.9139" />
                <PreSize X="0.0562" Y="0.1111" />
                <TextColor A="255" R="65" G="65" B="70" />
                <NormalFileData Type="Normal" Path="login/image/zcmdwc_loading/icon_kefu.png" Plist="" />
                <OutlineColor A="255" R="0" G="63" B="198" />
                <ShadowColor A="255" R="0" G="0" B="0" />
              </AbstractNodeData>
              <AbstractNodeData Name="Node_Tips" ActionTag="1077207052" Tag="935" IconVisible="True" RightMargin="1280.0000" TopMargin="720.0000" ctype="SingleNodeObjectData">
                <Size X="0.0000" Y="0.0000" />
                <Children>
                  <AbstractNodeData Name="TXT_version" ActionTag="2005517172" Tag="293" IconVisible="False" PositionPercentYEnabled="True" HorizontalEdge="RightEdge" LeftMargin="1220.0000" RightMargin="-1220.0000" FontSize="20" LabelText="" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                    <Size X="0.0000" Y="0.0000" />
                    <AnchorPoint ScaleX="1.0000" ScaleY="0.5000" />
                    <Position X="1220.0000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
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
              <AbstractNodeData Name="panel_loadPanel" ActionTag="1276492354" VisibleForFrame="False" Tag="288" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="540.0000" RightMargin="540.0000" TopMargin="421.8000" BottomMargin="148.2000" TouchEnable="True" ClipAble="False" BackColorAlpha="240" ColorAngle="0.0000" Scale9Width="1" Scale9Height="1" ctype="PanelObjectData">
                <Size X="200.0000" Y="150.0000" />
                <Children>
                  <AbstractNodeData Name="Sprite_18" ActionTag="-1391326620" Tag="289" RotationSkewX="216.0000" RotationSkewY="215.9974" IconVisible="False" PositionPercentXEnabled="True" LeftMargin="51.2200" RightMargin="49.7800" TopMargin="10.6200" BottomMargin="40.3800" ctype="SpriteObjectData">
                    <Size X="99.0000" Y="99.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="100.7200" Y="89.8800" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.5036" Y="0.5992" />
                    <PreSize X="0.4950" Y="0.6600" />
                    <FileData Type="Normal" Path="login/image/loading/quan_bg.png" Plist="" />
                    <BlendFunc Src="1" Dst="771" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Sprite_19" ActionTag="628386222" Alpha="159" Tag="290" RotationSkewX="216.0000" RotationSkewY="215.9965" IconVisible="False" PositionPercentXEnabled="True" LeftMargin="51.2200" RightMargin="49.7800" TopMargin="10.6200" BottomMargin="40.3800" ctype="SpriteObjectData">
                    <Size X="99.0000" Y="99.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="100.7200" Y="89.8800" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.5036" Y="0.5992" />
                    <PreSize X="0.4950" Y="0.6600" />
                    <FileData Type="Normal" Path="login/image/loading/quan.png" Plist="" />
                    <BlendFunc Src="1" Dst="771" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Sprite_13" ActionTag="-1955056196" Tag="291" IconVisible="False" PositionPercentXEnabled="True" LeftMargin="51.2200" RightMargin="49.7800" TopMargin="10.6200" BottomMargin="40.3800" ctype="SpriteObjectData">
                    <Size X="99.0000" Y="99.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="100.7200" Y="89.8800" />
                    <Scale ScaleX="-1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.5036" Y="0.5992" />
                    <PreSize X="0.4950" Y="0.6600" />
                    <FileData Type="Normal" Path="login/image/loading/tx.png" Plist="" />
                    <BlendFunc Src="1" Dst="771" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="text_loadTip" ActionTag="634129480" Tag="292" IconVisible="False" PositionPercentXEnabled="True" LeftMargin="100.0000" RightMargin="100.0000" TopMargin="150.0000" FontSize="24" LabelText="" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                    <Size X="0.0000" Y="0.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="100.0000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.5000" />
                    <PreSize X="0.0000" Y="0.0000" />
                    <OutlineColor A="255" R="0" G="0" B="0" />
                    <ShadowColor A="255" R="0" G="0" B="0" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="640.0000" Y="223.2000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.5000" Y="0.3100" />
                <PreSize X="0.1563" Y="0.2083" />
                <SingleColor A="255" R="150" G="200" B="255" />
                <FirstColor A="255" R="150" G="200" B="255" />
                <EndColor A="255" R="255" G="255" B="255" />
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
            <FirstColor A="255" R="150" G="200" B="255" />
            <EndColor A="255" R="255" G="255" B="255" />
            <ColorVector ScaleX="1.0000" ScaleY="0.0000" />
          </AbstractNodeData>
        </Children>
      </ObjectData>
    </Content>
  </Content>
</GameFile>