<GameFile>
  <PropertyGroup Name="UpdateScene" Type="Layer" ID="5c7840ad-159f-4a42-9ae8-2f23230e9245" Version="3.10.0.0" />
  <Content ctype="GameProjectContent">
    <Content>
      <Animation Duration="40" Speed="0.5000" ActivedAnimationName="dotAnimation">
        <Timeline ActionTag="-375609193" Property="VisibleForFrame">
          <BoolFrame FrameIndex="0" Tween="False" Value="False" />
          <BoolFrame FrameIndex="10" Tween="False" Value="True" />
          <BoolFrame FrameIndex="20" Tween="False" Value="True" />
          <BoolFrame FrameIndex="40" Tween="False" Value="False" />
        </Timeline>
        <Timeline ActionTag="61577871" Property="VisibleForFrame">
          <BoolFrame FrameIndex="0" Tween="False" Value="False" />
          <BoolFrame FrameIndex="20" Tween="False" Value="True" />
          <BoolFrame FrameIndex="40" Tween="False" Value="False" />
        </Timeline>
        <Timeline ActionTag="-875903408" Property="VisibleForFrame">
          <BoolFrame FrameIndex="0" Tween="False" Value="False" />
          <BoolFrame FrameIndex="30" Tween="False" Value="True" />
          <BoolFrame FrameIndex="40" Tween="False" Value="False" />
        </Timeline>
      </Animation>
      <AnimationList>
        <AnimationInfo Name="dotAnimation" StartIndex="0" EndIndex="40">
          <RenderColor A="255" R="34" G="56" B="133" />
        </AnimationInfo>
      </AnimationList>
      <ObjectData Name="Scene" ctype="GameLayerObjectData">
        <Size X="1280.0000" Y="720.0000" />
        <Children>
          <AbstractNodeData Name="image_logo" ActionTag="-461517144" Tag="94" RotationSkewX="270.0000" RotationSkewY="270.0000" IconVisible="True" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="280.0000" RightMargin="280.0000" TopMargin="-280.0000" BottomMargin="-280.0000" CascadeColorEnabled="True" CascadeOpacityEnabled="True" ctype="ImageViewObjectData">
            <Size X="720.0000" Y="1280.0000" />
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="640.0000" Y="360.0000" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.5000" Y="0.5000" />
            <PreSize X="0.5625" Y="1.7778" />
            <FileData Type="Normal" Path="login/image/zcmdwc_loading/loadingBg.png" Plist="" />
          </AbstractNodeData>
          <AbstractNodeData Name="image_update" ActionTag="-908500255" Tag="3" IconVisible="True" PositionPercentXEnabled="True" PositionPercentYEnabled="True" CascadeColorEnabled="True" CascadeOpacityEnabled="True" ctype="ImageViewObjectData">
            <Size X="1280.0000" Y="720.0000" />
            <Children>
              <AbstractNodeData Name="nodeTitle" ActionTag="1519442184" Tag="540" IconVisible="True" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="640.0000" RightMargin="640.0000" TopMargin="360.0000" BottomMargin="360.0000" CascadeColorEnabled="True" CascadeOpacityEnabled="True" StretchWidthEnable="False" StretchHeightEnable="False" ctype="SingleNodeObjectData">
                <Size X="0.0000" Y="0.0000" />
                <Children>
                  <AbstractNodeData Name="sprite_logo" ActionTag="1197262440" Tag="541" IconVisible="True" LeftMargin="-536.5000" RightMargin="-536.5000" TopMargin="-264.0000" BottomMargin="-114.0000" CascadeColorEnabled="True" CascadeOpacityEnabled="True" StretchWidthEnable="False" StretchHeightEnable="False" IntelliShadingEnabled="False" ctype="SpriteObjectData">
                    <Size X="1073.0000" Y="378.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position Y="75.0000" />
                    <Scale ScaleX="0.7000" ScaleY="0.7000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition />
                    <PreSize X="0.0000" Y="0.0000" />
                    <FileData Type="Normal" Path="login/image/loading/logo.png" Plist="" />
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
              <AbstractNodeData Name="sprite_tips" ActionTag="-1804594812" VisibleForFrame="False" Tag="146" IconVisible="True" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="349.5000" RightMargin="349.5000" TopMargin="486.6080" BottomMargin="189.3920" CascadeColorEnabled="True" CascadeOpacityEnabled="True" StretchWidthEnable="False" StretchHeightEnable="False" IntelliShadingEnabled="False" ctype="SpriteObjectData">
                <Size X="581.0000" Y="44.0000" />
                <Children>
                  <AbstractNodeData Name="Sprite_1" ActionTag="119826426" Tag="5" IconVisible="True" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="223.5000" RightMargin="223.5000" TopMargin="9.0000" BottomMargin="9.0000" CascadeColorEnabled="True" CascadeOpacityEnabled="True" StretchWidthEnable="False" StretchHeightEnable="False" IntelliShadingEnabled="False" ctype="SpriteObjectData">
                    <Size X="134.0000" Y="26.0000" />
                    <Children>
                      <AbstractNodeData Name="Sprite_2" ActionTag="-375609193" VisibleForFrame="False" Tag="6" IconVisible="True" LeftMargin="142.9852" RightMargin="-12.9852" TopMargin="-1.6480" BottomMargin="1.6480" CascadeColorEnabled="True" CascadeOpacityEnabled="True" StretchWidthEnable="False" StretchHeightEnable="False" IntelliShadingEnabled="False" ctype="SpriteObjectData">
                        <Size X="4.0000" Y="26.0000" />
                        <AnchorPoint ScaleX="0.5000" />
                        <Position X="144.9852" Y="1.6480" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="1.0820" Y="0.0634" />
                        <PreSize X="0.0299" Y="1.0000" />
                        <FileData Type="Normal" Path="login/image/loading/tjylc_loading_wenzi2.png" Plist="" />
                        <BlendFunc Src="1" Dst="771" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Sprite_3" ActionTag="61577871" VisibleForFrame="False" Tag="7" IconVisible="True" LeftMargin="151.1835" RightMargin="-21.1835" TopMargin="-1.6480" BottomMargin="1.6480" CascadeColorEnabled="True" CascadeOpacityEnabled="True" StretchWidthEnable="False" StretchHeightEnable="False" IntelliShadingEnabled="False" ctype="SpriteObjectData">
                        <Size X="4.0000" Y="26.0000" />
                        <AnchorPoint ScaleX="0.5000" />
                        <Position X="153.1835" Y="1.6480" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="1.1432" Y="0.0634" />
                        <PreSize X="0.0299" Y="1.0000" />
                        <FileData Type="Normal" Path="login/image/loading/tjylc_loading_wenzi2.png" Plist="" />
                        <BlendFunc Src="1" Dst="771" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Sprite_4" ActionTag="-875903408" VisibleForFrame="False" Tag="8" IconVisible="True" LeftMargin="159.3818" RightMargin="-29.3818" TopMargin="-1.6480" BottomMargin="1.6480" CascadeColorEnabled="True" CascadeOpacityEnabled="True" StretchWidthEnable="False" StretchHeightEnable="False" IntelliShadingEnabled="False" ctype="SpriteObjectData">
                        <Size X="4.0000" Y="26.0000" />
                        <AnchorPoint ScaleX="0.5000" />
                        <Position X="161.3818" Y="1.6480" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="1.2043" Y="0.0634" />
                        <PreSize X="0.0299" Y="1.0000" />
                        <FileData Type="Normal" Path="login/image/loading/tjylc_loading_wenzi2.png" Plist="" />
                        <BlendFunc Src="1" Dst="771" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="290.5000" Y="22.0000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.5000" Y="0.5000" />
                    <PreSize X="0.2306" Y="0.5909" />
                    <FileData Type="Normal" Path="login/image/loading/tjylc_loading_wenzi1.png" Plist="" />
                    <BlendFunc Src="1" Dst="771" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="640.0000" Y="211.3920" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.5000" Y="0.2936" />
                <PreSize X="0.4539" Y="0.0611" />
                <FileData Type="Normal" Path="login/image/loading/text_bg.png" Plist="" />
                <BlendFunc Src="1" Dst="771" />
              </AbstractNodeData>
              <AbstractNodeData Name="image_loading" ActionTag="1512543968" VisibleForFrame="False" Tag="3" IconVisible="True" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="247.0200" RightMargin="255.9800" TopMargin="632.2360" BottomMargin="68.7640" CascadeColorEnabled="True" CascadeOpacityEnabled="True" ctype="ImageViewObjectData">
                <Size X="777.0000" Y="19.0000" />
                <Children>
                  <AbstractNodeData Name="loadingBar_percent" ActionTag="-1164342171" Tag="4" IconVisible="True" PositionPercentXEnabled="True" PositionPercentYEnabled="True" TopMargin="3.9995" BottomMargin="-3.9995" ProgressInfo="0" CascadeColorEnabled="True" CascadeOpacityEnabled="True" FlipX="False" FlipY="False" ctype="LoadingBarObjectData">
                    <Size X="777.0000" Y="19.0000" />
                    <Children>
                      <AbstractNodeData Name="text_percent" ActionTag="-1782672192" Tag="9" IconVisible="True" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="388.5000" RightMargin="388.5000" TopMargin="9.5000" BottomMargin="9.5000" FontSize="20" LabelText="" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" CascadeColorEnabled="True" CascadeOpacityEnabled="True" AreaWidth="0" AreaHeight="0" FontName="" GlowEnabled="False" BoldEnabled="False" UnderlineEnabled="False" ItalicsEnabled="False" StrikethroughEnabled="False" ctype="TextObjectData">
                        <Size X="0.0000" Y="0.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="388.5000" Y="9.5000" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.5000" Y="0.5000" />
                        <PreSize X="0.0000" Y="0.0000" />
                        <OutlineColor A="255" R="0" G="0" B="0" />
                        <ShadowColor A="255" R="0" G="0" B="0" />
                        <GlowColor R="0" G="0" B="0" A="255" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="particle_guang" ActionTag="2035277409" Tag="143" IconVisible="True" PositionPercentYEnabled="True" RightMargin="777.0000" TopMargin="9.5000" BottomMargin="9.5000" CascadeColorEnabled="True" CascadeOpacityEnabled="True" StretchWidthEnable="False" StretchHeightEnable="False" ctype="ParticleObjectData">
                        <Size X="0.0000" Y="0.0000" />
                        <AnchorPoint />
                        <Position Y="9.5000" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition Y="0.5000" />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="Normal" Path="login/image/loading/loading_eff.plist" Plist="" />
                        <BlendFunc Src="770" Dst="1" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="388.5000" Y="5.5005" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.5000" Y="0.2895" />
                    <PreSize X="1.0000" Y="1.0000" />
                    <ImageFileData Type="Normal" Path="login/image/loading/tjylc_loading_jdt2.png" Plist="" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="635.5200" Y="78.2640" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.4965" Y="0.1087" />
                <PreSize X="0.6070" Y="0.0264" />
                <FileData Type="Normal" Path="login/image/loading/tjylc_loading_jdt1.png" Plist="" />
              </AbstractNodeData>
              <AbstractNodeData Name="text_version" ActionTag="-1594934167" Tag="98" IconVisible="True" PositionPercentYEnabled="True" HorizontalEdge="RightEdge" LeftMargin="1263.8059" RightMargin="16.1941" TopMargin="670.8960" BottomMargin="49.1040" FontSize="20" LabelText="" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" CascadeColorEnabled="True" CascadeOpacityEnabled="True" AreaWidth="0" AreaHeight="0" FontName="" GlowEnabled="False" BoldEnabled="False" UnderlineEnabled="False" ItalicsEnabled="False" StrikethroughEnabled="False" ctype="TextObjectData">
                <Size X="0.0000" Y="0.0000" />
                <AnchorPoint ScaleX="1.0000" ScaleY="0.5000" />
                <Position X="1263.8059" Y="49.1040" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.9873" Y="0.0682" />
                <PreSize X="0.0000" Y="0.0000" />
                <OutlineColor A="255" R="0" G="0" B="0" />
                <ShadowColor A="255" R="0" G="0" B="0" />
                <GlowColor R="0" G="0" B="0" A="255" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="640.0000" Y="360.0000" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.5000" Y="0.5000" />
            <PreSize X="1.0000" Y="1.0000" />
            <FileData Type="Normal" Path="login/image/loading/zcm_zjm_bg.jpg" Plist="" />
          </AbstractNodeData>
        </Children>
      </ObjectData>
    </Content>
  </Content>
</GameFile>